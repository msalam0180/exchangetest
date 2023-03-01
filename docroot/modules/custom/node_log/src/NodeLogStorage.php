<?php

namespace Drupal\node_log;

use Drupal\node_log\StorageBackend\StorageBackendInterface;

/**
 * Writes node log events to enabled logging destinations.
 *
 * @package Drupal\node_log
 */
class NodeLogStorage {
  /**
   * An array of available log destinations to be written to.
   *
   * @var array
   */
  protected $storageBackends;

  /**
   * Writes the node event to each available logging destination.
   *
   * @param \Drupal\node_log\NodeLogEventInterface $event
   *   The node event to be logged.
   */
  public function save(NodeLogEventInterface $event) {
    foreach ($this->sortStorageBackends() as $storage_backend) {
      $storage_backend->save($event);
    }
  }

  /**
   * Adds a log destination to the processing pipeline.
   *
   * @param \Drupal\node_log\StorageBackend\StorageBackendInterface $storage_backend
   *   The logging destination to write events to.
   * @param int $priority
   *   A priority specification for the storage backend s.
   *
   *   Must be a positive integer.
   *
   *   Lower number storage backend s are processed
   *   before higher number storage backend s.
   */
  public function addStorageBackend(StorageBackendInterface $storage_backend, $priority = 0) {
    $this->storageBackends[$priority][] = $storage_backend;
  }

  /**
   * Sorts the available logging destinations by priority.
   *
   * @return array
   *   The sorted array of logging destinations.
   */
  protected function sortStorageBackends() {
    $sorted = [];
    krsort($this->storageBackends);

    foreach ($this->storageBackends as $storage_backends) {
      $sorted = array_merge($sorted, $storage_backends);
    }
    return $sorted;
  }

}
