<?php

namespace Drupal\node_log\Entity;

use Drupal\views\EntityViewsData;

/**
 * Provides Views data for Node log entities.
 */
class NodeLogViewsData extends EntityViewsData {

  /**
   * {@inheritdoc}
   */
  public function getViewsData() {
    $data = parent::getViewsData();
    
    $data['node_log']['event']['filter'] = [
      'id' => 'in_operator',
      'options callback' => 'Drupal\node_log\Entity\NodeLogViewsData::getEventOptions',
    ];

    $data['node_log']['entity_type']['filter'] = [
      'id' => 'in_operator',
      'options callback' => 'Drupal\node_log\Entity\NodeLogViewsData::getEntityTypeOptions',
    ];

    $data['node_log']['created']['filter']['id'] = 'node_log_date';

    return $data;
  }

  /**
   * Get event options.
   */
  public static function getEventOptions() {
    return [
      'read'   => t('Read'),
    ];
  }

  /**
   * Get entity type options.
   */
  public static function getEntityTypeOptions() {
    $entity_manager = \Drupal::entityTypeManager();
    $subscribers = \Drupal::service('node_log.logger')->getEventSubscribers();
    $return = [];

    /* @var \Drupal\node_log\EventSubscriber\EventSubscriberInterface[] $subscribers */
    foreach ($subscribers as $subscriber) {
      $entity_type = $subscriber->getEntityType();
      if ($entity_manager->hasDefinition($entity_type)) {
        $definition = $entity_manager->getDefinition($entity_type);
        $return[$entity_type] = $definition->getLabel();
      }
    }

    return $return;
  }

}
