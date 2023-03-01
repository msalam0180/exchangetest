<?php

namespace Drupal\Driver\Fields\Drupal8;

/**
 * Entity Reference field handler for Drupal 8.
 */
class EntityReferenceRevisionsHandler extends AbstractHandler {

  /**
   * {@inheritdoc}
   */
  public function expand($values) {
    $entity_type_id = $this->fieldInfo->getSetting('target_type');

    $entity_ids = \Drupal::entityQuery($entity_type_id)
      ->condition('uuid', $values, 'IN')
      ->execute();
    $entities = \Drupal::entityTypeManager()
      ->getStorage($entity_type_id)
      ->loadMultiple($entity_ids);

    if (empty($entities)) {
      throw new \Exception(sprintf("No entity '%s' of type '%s' exists.", $values, $entity_type_id));
    }
    return $entities;
  }

}
