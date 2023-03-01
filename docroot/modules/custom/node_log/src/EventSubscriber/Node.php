<?php

namespace Drupal\node_log\EventSubscriber;

use Drupal\node_log\NodeLogEventInterface;
use Drupal\Core\Render\Markup;

/**
 * Processes node entity events.
 *
 * @package Drupal\node_log\EventSubscriber
 */
class Node implements EventSubscriberInterface {

  /**
   * {@inheritdoc}
   */
  public function reactTo(NodeLogEventInterface $event) {
    $entity = $event->getEntity();
    if ($entity->getEntityTypeId() != $this->getEntityType()) {
      return FALSE;
    }
    $event_type = $event->getEventType();
    /** @var \Drupal\node\NodeInterface $entity */
    $current_state = $entity->isPublished() ? 'published' : 'unpublished';
    $previous_state = '';
    if (isset($entity->original)) {
      $previous_state = $entity->original->isPublished() ? 'published' : 'unpublished';
    }
    $args = [
      '@title' => Markup::create($entity->label()),
    ];

    if ($event_type == 'read') {
      $event
        ->setMessage(t('@title was read.', $args))
        ->setPreviousState($previous_state)
        ->setCurrentState($current_state);
      return TRUE;
    }

    return FALSE;
  }

  /**
   * {@inheritdoc}
   */
  public function getEntityType() {
    return 'node';
  }

}
