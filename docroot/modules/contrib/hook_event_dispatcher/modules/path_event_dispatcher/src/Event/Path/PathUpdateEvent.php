<?php

namespace Drupal\path_event_dispatcher\Event\Path;

use Drupal\path_event_dispatcher\PathHookEvents;

/**
 * Class UpdatePathEvent.
 */
final class PathUpdateEvent extends AbstractPathEvent {

  /**
   * Get the dispatcher type.
   *
   * @return string
   *   The dispatcher type.
   */
  public function getDispatcherType(): string {
    return PathHookEvents::PATH_UPDATE;
  }

}
