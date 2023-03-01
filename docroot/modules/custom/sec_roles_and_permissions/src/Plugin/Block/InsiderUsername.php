<?php

namespace Drupal\sec_roles_and_permissions\Plugin\Block;

use Drupal\Core\Access\AccessResult;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Session\AccountInterface;


/**
 * Provides a block with a simple text.
 *
 * @Block(
 *   id = "insider_username_block",
 *   admin_label = @Translation("Insider User Name block"),
 * )
 */
class InsiderUsername extends BlockBase {
  /**
   * {@inheritdoc}
   */
  public function build() {
    return [
      '#markup' => "<div class='username'>" . $this->t('Welcome, ' . self::insider_user_name_format()) . "</div>",
    ];
  }

  /**
   * {@inheritdoc}
   */
  protected function blockAccess(AccountInterface $account) {
    return AccessResult::allowedIfHasPermission($account, 'access content');
  }

  /**
   * {@inheritdoc}
   */
  public function blockForm($form, FormStateInterface $form_state) {
    $config = $this->getConfiguration();

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function blockSubmit($form, FormStateInterface $form_state) {
    $this->configuration['insider_username_block_settings'] = $form_state->getValue('insider_username_block_settings');
  }

  /**
   * Returns a formatted username.
   *
   * @return string
   */
  public static function insider_user_name_format() {
    // If Authenticated, return the username string.
    if (\Drupal::currentUser()->isAuthenticated()) {
      // Store the display name since we'll use it a couple of times later
      $display_name = \Drupal::currentUser()->getDisplayName();
      // Returns the first part of the user name portion of the email (from $display_name)
      // If no email, return $display_name
      return strpos($display_name, '@') !== false ?
        substr($display_name, 0, strpos($display_name, '@'))
        : $display_name;
    }
    // Unauthenticated. Return empty string.
    return '';
  }

  /**
   * {@inheritdoc}
   */
  public function getCacheMaxAge() {
    return 0;
  }
}
