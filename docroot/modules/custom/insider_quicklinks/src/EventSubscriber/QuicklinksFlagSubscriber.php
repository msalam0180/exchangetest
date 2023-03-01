<?php

/**
 * @file
 * Contains \Drupal\insider_quicklinks\EventSubscriber\QuicklinksFlagSubscriber.
 */

namespace Drupal\insider_quicklinks\EventSubscriber;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Drupal\flag\Event\FlagEvents;
use Drupal\flag\Event\FlaggingEvent;
use Drupal\flag\Event\UnflaggingEvent;

class QuicklinksFlagSubscriber implements EventSubscriberInterface {

  public function onFlag(FlaggingEvent $event) {
    $flagging = $event->getFlagging();

    $entity_nid = $flagging->getFlaggable()->id();
    // Get the limit
    $limit = quicklinks_limit();

    // Call the flag service
    $flag_service = \Drupal::service('flag');

    // Get the Quicklinks flag
    $flag = $flag_service->getFlagById('user_quicklinks');

    // Get the entity for the link
    $node = \Drupal::entityTypeManager()->getStorage('node')->load($entity_nid);


    // Get number of user flaggings
    // Note: This list is already updated with the recent flagging which is why the view needs
    //       to have a limit higher than what they are allowed to see.
    //       Otherwise we would always get e.g. 10 if they actually flagged 11 because the view limited it.
    $user_quicklinks_count = userFlagCount(\Drupal::currentUser());

    // Get the Quicklinks branding string in plural form
    $quicklink_branding = quicklinks_branding(true);

    // If the user is at the threshold do not allow the flagging
    if ($user_quicklinks_count > $limit) {
      // Let the user know they can only have $limit amounts of quicklinks
      \Drupal::messenger()->addStatus("You can only have ${limit} ${quicklink_branding}. To add more, you need to remove some ${quicklink_branding} from your list.");

      // Unflag this item
      $flag_service->unflag($flag, $node, \Drupal::currentUser());
    }
  }

  public static function getSubscribedEvents() {
    // Setup the event array
    $events = [];

    // Add our onFlag method we created here to the FlagEvents for when an entity is flagged
    $events[FlagEvents::ENTITY_FLAGGED][] = ['onFlag'];

    // Return our events
    return $events;
  }
}
