<?php

namespace Drupal\node_log\EventSubscriber;

use Drupal\node_log\NodeLogEventInterface;

/**
 * Defines an event subscriber for responding to events.
 *
 * @package Drupal\node_log\EventSubscriber
 */
interface EventSubscriberInterface {

  /**
   * Processes an event.
   *
   * @param \Drupal\node_log\NodeLogEventInterface $event
   *   The node event.
   *
   * @return bool
   *   TRUE if the event subscriber handled the event.
   */
  public function reactTo(NodeLogEventInterface $event);

  /**
   * Return entity type machine name.
   */
  public function getEntityType();

}
