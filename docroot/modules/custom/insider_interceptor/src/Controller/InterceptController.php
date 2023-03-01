<?php

namespace Drupal\insider_interceptor\Controller;

use Drupal\Core\Url;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Drupal\Core\Controller\ControllerBase;

/**
 * Handles legacy Rhythmyx internal urls and maps sys_contentid values to Drupal Entity IDs.
 */
class InterceptController extends ControllerBase {

  /**
   * URL query attribute to indicate the wrapper used to render a request.
   *
   * The wrapper format determines how the HTML is wrapped, for example in a
   * modal dialog.
   */
  const LEGACY_PARAM = 'sys_contentid';
  /**
   * {@inheritdoc}
   */
  public function intercept() {
    $legacyId = \Drupal::request()->query->get(InterceptController::LEGACY_PARAM);
    if (!empty($legacyId)) {
      $nodeId = $this->_getNodeByLegacyId($legacyId);
      if (!empty($nodeId)) {
        $nodeUrl = Url::fromRoute('entity.node.canonical', ['node' => $nodeId])->toString();
        return new RedirectResponse($nodeUrl);
      }
    }

    $build = [
      '#markup' => t('Unable to process this request'),
    ];
    return $build;
  }

  function _getNodeByLegacyId($legacyId) {
    $nodeId = \Drupal::database()
      ->query("select destid1 from migrate_map_insider_all where sourceid1 = :legacy_id",
        [':legacy_id' => intval($legacyId)])
      ->fetchField();
    return $nodeId;
  }
}
