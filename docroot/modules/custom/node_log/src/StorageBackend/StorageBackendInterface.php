<?php

namespace Drupal\node_log\StorageBackend;

use Drupal\node_log\NodeLogEventInterface;

/**
 * Defines a logging storage backend to write node events to.
 *
 * @package Drupal\node_log\StorageBackend
 */
interface StorageBackendInterface {

  /**
   * Writes the event to the storage backend's storage system.
   *
   * @param \Drupal\node_log\NodeLogEventInterface $event
   *   The event to be written to the log.
   */
  public function save(NodeLogEventInterface $event);

}
