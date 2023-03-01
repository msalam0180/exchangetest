<?php

/**
 * @file
 * Contains \Drupal\insider_quicklinks\EventSubscriber\QuicklinksFlagSubscriber.
 */

namespace Drupal\insider_poll\EventSubscriber;

use Drupal\flag\Entity\Flag;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Drupal\flag\Event\FlagEvents;
use Drupal\flag\Event\FlaggingEvent;

class PollFlagSubscriber implements EventSubscriberInterface
{

  public function onFlag(FlaggingEvent $event)
  {
    $flagging = $event->getFlagging();

    if($flagging->getFlaggable()->bundle() == 'poll' && $flagging->getFlagId() == 'featured_poll'){

      // Call the flag service
      $flag_service = \Drupal::service('flag');

      // Get featured poll id
      $featured_poll_id = $flagging->getFlaggable()->id();

      // Get the Featured Poll flag
      $flag = $flagging->getFlag();

      // Get all poll entities
      $poll_entities = \Drupal::entityTypeManager()->getStorage('poll')->loadMultiple();

      // Search polls and unflag any that do no match currently flagged entity
      foreach($poll_entities as $poll){
        if($poll->id() != $featured_poll_id && $flag->isFlagged($poll)){
          $flag_service->unflag($flag, $poll);
          break;
        }
      }
    }
    
  }

  public static function getSubscribedEvents()
  {
      // Setup the event array
      $events = [];

      // Add our onFlag method we created here to the FlagEvents for when an entity is flagged
      $events[FlagEvents::ENTITY_FLAGGED][] = ['onFlag'];

      // Return our events
      return $events;
  }
}

