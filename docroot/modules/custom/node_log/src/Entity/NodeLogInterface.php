<?php

namespace Drupal\node_log\Entity;

use Drupal\Core\Entity\ContentEntityInterface;
use Drupal\Core\Entity\EntityChangedInterface;
use Drupal\user\EntityOwnerInterface;

/**
 * Provides an interface for defining Node log entities.
 *
 * @ingroup node_log
 */
interface NodeLogInterface extends ContentEntityInterface, EntityChangedInterface, EntityOwnerInterface {

  /**
   * Gets the Node log creation timestamp.
   *
   * @return int
   *   Creation timestamp of the Node log.
   */
  public function getCreatedTime();

  /**
   * Sets the Node log creation timestamp.
   *
   * @param int $timestamp
   *   The Node log creation timestamp.
   *
   * @return \Drupal\Node_log\Entity\NodeLogInterface
   *   The called Node log entity.
   */
  public function setCreatedTime($timestamp);

}
