<?php

/**
 * @file
 * Contains
 *   \Drupal\insider_comments\EventSubscriber\InsiderCommentsFlagSubscriber.
 */

namespace Drupal\insider_comments\EventSubscriber;

use Drupal;
use Drupal\Core\Entity\EntityInterface;
use Drupal\flag\Event\FlagEvents;
use Drupal\flag\Event\FlaggingEvent;
use Drupal\flag\Event\UnflaggingEvent;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;

class InsiderCommentsFlagSubscriber implements EventSubscriberInterface {

  public static function getSubscribedEvents() {
    // Setup the event array
    $events = [];

    // Add our onFlag and onUnflag methods we created here to the appropriate
    //  FlagEvents action.
    $events[FlagEvents::ENTITY_FLAGGED][] = ['onFlag'];
    $events[FlagEvents::ENTITY_UNFLAGGED][] = ['onUnflag'];

    // Return our events
    return $events;
  }

  public function onFlag(FlaggingEvent $event) {
    // Get the flagging.
    $flagging = $event->getFlagging();

    // If a comment was marked inappropriate.
    if ($flagging->getFlagId() == "mark_comment_as_inappropriate" && $flagging->getFlaggable()
        ->getEntityTypeId() == "comment") {

      // Get the comment ID.
      $entity_nid = $flagging->getFlaggable()->id();

      // Get a copy of the comment.
      /** @var EntityInterface $entity */
      $entity = Drupal::entityTypeManager()
        ->getStorage('comment')
        ->load($entity_nid);

        // Set the comment body to the 'deleted' text.
        $entity->comment_body = insider_comments_comment_deleted_text();

        // Save the comment.
        $entity->save();
    }
  }

  public function onUnflag(UnflaggingEvent $event) {
    // Get the flaggings array. That's what we get with UnflaggingEvent.
    // I don't know why it's different than with FlaggingEvent.
    $flaggings = $event->getFlaggings();

    // Get the flagging.
    /** @var \Drupal\flag\FlaggingInterface $flagging */
    $flagging = array_pop($flaggings);

    // If a comment was restored.
    if ($flagging->getFlagId() == "mark_comment_as_inappropriate" && $flagging->getFlaggable()
        ->getEntityTypeId() == "comment") {
      // Get the entity ID.
      $entity_id = $flagging->getFlaggable()->id();

      // Load the entity so we can restore it's text.
      /** @var EntityInterface $entity */
      $entity = Drupal::entityTypeManager()
        ->getStorage('comment')
        ->load($entity_id);

      // Restore the comment body from backup.
      $entity->comment_body = $entity->field_comment_backup;

      // Save the comment.
      $entity->save();
    }
  }

}
