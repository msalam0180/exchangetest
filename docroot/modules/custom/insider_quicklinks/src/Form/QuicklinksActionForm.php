<?php

/**
 * @file
 * Contains \Drupal\resume\Form\ResumeForm.
 */

namespace Drupal\insider_quicklinks\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;

class QuicklinksActionForm extends FormBase {
  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'quicklinks_action_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    $form['quicklinks_reset'] = array(
      '#type' => 'select',
      '#title' => ('Reset My  ' . quicklinks_branding(true)),
      '#options' => array(
        'none' => t('- Select -'),
        'all' => t('Remove all ' . quicklinks_branding(true)),
        'default' => t('Reset to default ' . quicklinks_branding(true)),
      ),
    );
    $form['actions']['#type'] = 'actions';
    $form['actions']['submit'] = array(
      '#type' => 'submit',
      '#value' => $this->t('Apply'),
      '#button_type' => 'primary',
    );

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $reset = $form_state->getValue('quicklinks_reset');

    switch ($reset) {
      case 'all':
        resetUserFlags(\Drupal::currentUser());
        $this->messenger()->addStatus('All your QuickLinks have been reset.');
        break;
      case 'default':
        setUserDefaultFlags(\Drupal::currentUser());
        $this->messenger()->addStatus('Your QuickLinks have been reset to default.');
        break;
      default:
        break;
    }
  }
}
