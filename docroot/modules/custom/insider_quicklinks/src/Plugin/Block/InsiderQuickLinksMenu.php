<?php

namespace Drupal\insider_quicklinks\Plugin\Block;


use Drupal\Component\Utility\UrlHelper;
use Drupal\Core\Access\AccessResult;
use Drupal\Core\Block\BlockBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\Core\Session\AccountInterface;
use Drupal\Core\Url;

/**
 * Provides a block formatted as a menu item.
 *
 * @Block(
 *   id = "insider_quicklinks_menu",
 *   admin_label = @Translation("QuickLinks Menu Block"),
 * )
 */
class InsiderQuickLinksMenu extends BlockBase {
  // Member variable for allowing to set the display of this for mobile
  protected $is_mobile;

  /**
   * {@inheritdoc}
   */
  public function build() {
    // Get the current user
    $user = \Drupal::currentUser();

    // If the uesr is anonymous we don't need to do all the bootstrapping
    $quicklinks = $user->isAnonymous() ? [] : $this->getQuickLinks($user);

    // If this is requested to be a mobile option then use the mobile twig
    if ($this->is_mobile) {
      // Fetches Quicklinks and returns the render template for the quicklinks mobile menu
      return [
        '#theme' => 'quicklinks_mobile_menu',
        '#quicklinks' => $quicklinks,
      ];
    }
    // Default State
    // Fetches Quicklinks and returns the render template for the quicklinks menu
    return [
      '#theme' => 'quicklinks_menu',
      '#quicklinks' => $quicklinks,
    ];
  }


  public function setMobile(bool $value) {
    $this->is_mobile = $value;
  }


  /**
   * Retrieves a list of twig-renderable quicklinks
   *
   * @return array
   */
  public function getQuickLinks(AccountInterface $user) {
    // Get user's flag count
    $user_flag_count = userFlagCount($user);

    // Bootstrap the user's quicklinks
    $this->bootstrapQuicklinks($user);

    // Get the data from the My Quicklinks View
    $my_quicklinks = getMyQuickLinks();

    // Create the quicklinks we need based on the view results
    $links = $this->createQuickLinksList($my_quicklinks);

    // Add edit link to the list of links
    $links[] = $this->createQuickLink('+ Edit', '/user/profile/quicklinks');

    // Return all the links we have
    return $links;
  }

  public function bootstrapQuicklinks(AccountInterface $user) {
    // Get the user id
    $user_id = $user->id();

    // Check if the user has a Quicklink profile (ever visited while Quicklinks is active)
    // Note: This is where we setup the user's default flags
    //       If we wanted them to keep tracking default flags (dynamically updated default menus)
    //       Then that could potentially take place here.
    $user_quicklinks_setup = \Drupal::state()->get('quicklinks_user_' . $user_id, false);

    // If the user hasn't created any, set the defaults
    if (!$user_quicklinks_setup) {
      // Set the user's default flags
      setUserDefaultFlags($user);
      // Set a variable to denote if the user has used quicklinks
      \Drupal::state()->set('quicklinks_user_' . $user_id, true);
    }
  }

  /**
   * Builds the list of formatted quicklinks for output
   *
   * @param array $quicklinks
   * @return array
   */
  public function createQuickLinksList(array $view_results) {
    // Setup the links array
    $links = array();

    // Build a link object for each link to send back for use in the tpl
    foreach ($view_results as $quicklink) {
      // Get the entity
      /** \Drupal\node\Entity\Node */
      $node = $quicklink->_entity;

      // Get the full url field value.
      $url_field = $node->get('field_url')->getValue();

      // Get the URI, title, (and options) of the link
      ['uri' => $uri, 'title' => $title, 'options' => $options] = $url_field[0];

      // Build the URL based on the URI
      $url = Url::fromUri($uri)->toString();

      // Test if the link is external
      $is_external_link = UrlHelper::isExternal($uri);

      // Add this link to the array of links
      $links[] = $this->createQuickLink($title, $url, $is_external_link);
    }

    return $links;
  }

  /**
   * Method for creating a formatted Quicklink object
   *
   * @param string $title
   * @param string $href
   * @return \stdClass
   */
  public function createQuickLink(string $title, string $href, bool $is_external = false) {
    // Instantiate the object
    // Using a stdclass because twig plays nicely with it vs our own class.
    $link = new \stdClass;

    // Set the title for the link
    $link->title = $title;

    // Set the href for the link
    $link->href = $href;

    // Set the target type based on whether the url is external (or not)
    $link->target = $is_external ? '_blank' : '_self';

    // Return the Link object
    return $link;
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
    $this->configuration['insider_quicklinks_menu'] = $form_state->getValue('insider_quicklinks_menu');
  }


  /**
   * {@inheritdoc}
   */
  public function getCacheMaxAge() {
    return 0;
  }
}
