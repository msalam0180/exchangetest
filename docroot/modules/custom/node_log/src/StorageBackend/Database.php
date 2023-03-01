<?php

namespace Drupal\node_log\StorageBackend;

use Drupal\node_log\NodeLogEventInterface;
use Drupal\node_log\Entity\NodeLog;
use Drupal\node_log\NodeLogEvent;

/**
 * Writes node events to a custom database table.
 *
 * @package Drupal\node_log\StorageBackend
 */
class Database implements StorageBackendInterface {

  /**
   * {@inheritdoc}
   */
  public function save(NodeLogEventInterface $event) {
    $values = [
      'entity_id' => $event->getEntity()->id(),
      'entity_type' => $event->getEntity()->getEntityTypeId(),
      'event' => $event->getEventType(),
      'previous_state' => $event->getPreviousState(),
      'current_state' => $event->getCurrentState(),
      'message' => $event->getMessage(),
    ];

      \Drupal::moduleHandler()->alter('node_log_save', $values, $event);
      NodeLog::create($values)->save();
  }

}
