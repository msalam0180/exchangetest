<?php

/**
 * @file
 * Contains \Drupal\sec_workflow\SecWorkflowSubscriber
 */

namespace Drupal\sec_workflow;

use Drupal\user\Entity\Role;
use Drupal\user\Entity\User;
use \Drupal\Core\Url;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Cmf\Component\Routing\RouteObjectInterface;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Drupal\core_event_dispatcher\Event\Entity\EntityViewEvent;
use Drupal\core_event_dispatcher\Event\Entity\EntityInsertEvent;
use Drupal\core_event_dispatcher\Event\Entity\EntityUpdateEvent;
use Drupal\core_event_dispatcher\Event\Form\FormAlterEvent;
use Drupal\core_event_dispatcher\FormHookEvents;
use Drupal\core_event_dispatcher\EntityHookEvents;
use Drupal\Core\Session\AccountInterface;

/**
 * Subscribes to the event_dispatcher events.
 * Symfony\Component\EventDispatcher\EventSubscriberInterface $event
 */

class SecWorkflowSubscriber implements EventSubscriberInterface {

  /**
   * @param \Drupal\core_event_dispatcher\Event\Form\FormAlterEvent $event
   */

  public function alterForm(FormAlterEvent $event): void {
    $form = &$event->getForm();
    // Immediately return if approver || creator !exist;
    if (empty($form['field_sec_content_approver']) && empty($form['field_creator'])) {
      return;
    }

    $userRoles = \Drupal::currentUser()->getRoles();

    if (isset($form['#entity_type']) && $form['#entity_type'] === "node") {
      $form['#attached']['library'][] = 'sec_workflow/sec_workflow';
    };

    $fieldContentApprover = !empty($form['field_sec_content_approver']) ? $form['field_sec_content_approver'] : null;
    $fieldContentCreator =  !empty($form['field_creator']) ? $form['field_creator'] : null;
    unset($form['field_sec_content_approver']);
    unset($form['field_creator']);

    //Set up our admin group setting
    $form['content_workflow'] = [
      '#type' => "details",
      '#open' => FALSE,
      '#title' => t('Workflow Options'),
      '#group' => 'advanced',
      '#weight' => 110
    ];

    // Get all the roles to move from review to publish. Revisit if not the same set of permissions for other publish states
    $roles = Role::loadMultiple();

    foreach ($roles as $role => $roleObj) {
      if ($roleObj->hasPermission('use needs_review_published transition')) {
        $approvedRoles[] = strtolower($roleObj->id());
      }
    }

    if (count(array_intersect($approvedRoles, $userRoles)) > 0) {
      $form['content_workflow'][] = $fieldContentApprover;
      $form['content_workflow'][] = $fieldContentCreator;
    } elseif (in_array('content_creator', $userRoles) || in_array('microsite_creator', $userRoles)) {
      $form['content_workflow'][] = $fieldContentApprover;
    }
  }

  /**
   * @param \Drupal\core_event_dispatcher\Event\Entity\EntityUpdateEvent $event
   */

  public function updateEntity(EntityUpdateEvent $event): void {
    $this->_secMailManagerSend($event);
  }

  /**
   * @param \Drupal\core_event_dispatcher\Event\Entity\EntityInsertEvent $event
   */

  public function insertEntity(EntityInsertEvent $event): void {
    $this->_secMailManagerSend($event);
  }

  /**
   * [secMailManagerSend description]
   * @param  [type] $event [EntityUpdateEvent $event]
   */

  private function _secMailManagerSend($event) {

    $entity = $event->getEntity();


    if ($entity->getEntityTypeId() !== "node") {
      return;
    }

    if (!$entity->hasField('field_sec_content_approver') && !$entity->hasField('field_creator')) {
      return;
    }

    $cState = null;
    $oState = null;

    if (isset($entity->moderation_state) && isset($entity->moderation_state->getValue()[0]['target_id'])) {
      $cState = $entity->hasField('moderation_state') ? $entity->moderation_state->getValue()[0]['target_id'] : null;
    }
    if (isset($entity->original->moderation_state) && isset($entity->original->moderation_state->getValue()[0]['target_id'])) {
      $oState = $entity->original !== NULL ? $entity->original->moderation_state->getValue()[0]['target_id'] : null;
    }

    if (isset($oState[0]['target_id'])) {
      $originalState = $oState[0]['target_id'];
    }

    if (isset($cState[0]['target_id'])) {
      $currentState = $cState[0]['target_id'];
    }

    $combinedStates = rtrim($oState . '--->' . $cState);

    switch ($combinedStates) {

      case '--->draft':
      case 'published--->archived':
      case 'needs_review--->needs_review':
        return;
        break;

      case 'published--->published':
      case '--->published':
      case 'archived--->published':
      case 'needs_review--->published':

        $users = $entity->get('field_creator')->getValue();
        $address = \Drupal::request()->getHost() . $entity->toUrl()->toString();

        if (!empty($entity->get('field_creator')->getValue()[0]['target_id'])) {
          $creator = $this->getNameByuid($entity->get('field_creator')->getValue()[0]['target_id']);
        } else {
          $creator = "User";
        }
        $params['subject'] = t(
          '@title is published',
          ['@title' => $entity->label()]
        );
        $params['message'] = t(
          "<p>The following content has been reviewed and approved in Drupal by @name. Click the link below to see the published content.</p>
          <p><a href='@url'>@title</a></p>",
          [
            '@name' => \Drupal::currentUser()->getAccountName(),
            '@title' => $entity->label(),
            '@url' => $address
          ]
        );
        break;

      case '--->needs_review':
      case 'published--->needs_review':
      case 'draft--->needs_review':

        $users = $entity->get('field_sec_content_approver')->getValue();
        $address = \Drupal::request()->getHost() . $entity->toUrl()->toString();
        if (!empty($entity->get('field_sec_content_approver')->getValue()[0]['target_id'])) {
          $approver = $this->getNameByuid($entity->get('field_sec_content_approver')->getValue()[0]['target_id']);
        } else {
          $approver = "User";
        }
        $params['subject'] = t(
          '@title is ready for review and approval',
          ['@title' => $entity->label()]
        );
        $params['message'] = t(
          "<p>The following content has been submitted for review and approval in Drupal by @name.</p>
          <p><a href='@url'>@title</a></p>
          <p>Comments: @revlog</p>
          <p>Click the above link to review this content, and take one of the following three actions:
          <ul><li>Approve to publish with no additional changes by selecting 'Save and Publish'.</li>
          <li>Make edits and then approve to publish.</li>
          <li>Make a comment in the Revision Log with details about requested changes, then route to the original submitter by selecting 'Save and Send Back to Draft'.
          Please note that if you do not see the above content in your Drupal review queue, it is possible that another content reviewer has already taken action on it.
          </li></ul></p>",
          [
            '@name' => \Drupal::currentUser()->getAccountName(),
            '@title' => $entity->label(),
            '@revlog' => $entity->revision_log->getValue()[0]['value'],
            '@url' => $address,
            '@user' => $approver
          ]
        );
        break;

      case 'published--->draft':
      case 'needs_review--->draft':

        $users = $entity->get('field_creator')->getValue();
        $address = \Drupal::request()->getHost() . $entity->toUrl()->toString();
        if (!empty($entity->get('field_creator')->getValue()[0]['target_id'])) {
          $creator = $this->getNameByuid($entity->get('field_creator')->getValue()[0]['target_id']);
        } else {
          $creator = "User";
        }
        $params['subject'] = t(
          '@title has been rejected and sent back for editing',
          ['@title' => $entity->label()]
        );
        $params['message'] = t(
          "<p>The following content has been reviewed and sent back for additional editing in Drupal by @name.</p>
          <p><a href='@url'>@title</a></p>
          <p>Comments: @revlog</p>
          <ul><li>Click the above link to open this content and review the requested updates in the Revision Log.</li>
          <li>After making edits, resubmit the content for review and approval by selecting 'Save and Request Review'.</li></ul>",
          [
            '@name' => \Drupal::currentUser()->getAccountName(),
            '@title' => $entity->label(),
            '@revlog' => $entity->revision_log->getValue()[0]['value'],
            '@url' => $address,
            '@user' => $creator
          ]
        );
    }

    $uids = [];
    $userMail = [];
    //Get all the Uid's from the content approver list;
    if (isset($users)) {
      foreach ($users as $key => $user) {
        $uids[] = $user['target_id'];
      }
    }

    if (empty($uids)) return;
    //Load all registered user object and get email values;
    $accounts = User::loadMultiple($uids);
    foreach ($accounts as $uid => $UserObject) {
      $userMail[] = $UserObject->getEmail();
    }
    //Setup MailManager service for email notification;
    $mailManager = \Drupal::service('plugin.manager.mail');
    $module = 'sec_workflow';
    $key = 'sec_content_workflow';
    $to = rtrim(implode(",", $userMail), ',');
    $langcode = \Drupal::currentUser()->getPreferredLangcode();
    $send = true;

    $result = $mailManager->mail($module, $key, $to, $langcode, $params, NULL, $send);

    if ($result['result'] !== true) {
      $message = t('There was a problem sending your email notification to @email for creating article @label.', ['@email' => $to, '@label' => $entity->label()]);
      \Drupal::messenger()->addError($message);
      \Drupal::logger('SEC Workflow')->error($message);
      return;
    } else {
      $message = t('An email notification has been sent to @email for review article @label.', ['@email' => $to, '@label' => $entity->label()]);
      \Drupal::messenger()->addStatus($message);
      \Drupal::logger('SEC Workflow')->notice($message);
    }
  }

  public function getNameByuid($uid) {
    $account = User::load($uid); // pass your uid
    $name = $account->getAccountName();
    return $name;
  }

  /**
   * {@inheritdoc}
   */
  public static function getSubscribedEvents() {
    if (
      class_exists('\Drupal\core_event_dispatcher\EntityHookEvents') &&
      class_exists('\Drupal\core_event_dispatcher\FormHookEvents')
    ) {
      return [
        // KernelEvents::REQUEST => 'updateUserRoles',
        FormHookEvents::FORM_ALTER => 'alterForm',
        EntityHookEvents::ENTITY_UPDATE => 'updateEntity',
        EntityHookEvents::ENTITY_INSERT => 'insertEntity',
      ];
    } else {
      return [];
    }
  }
}
