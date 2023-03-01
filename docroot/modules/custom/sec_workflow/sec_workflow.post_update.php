<?php

use Drupal\Core\Field\BaseFieldDefinition;

/**
 * Manually add the moderation_state field to taxonomy terms post 8.7 update.
 * See https://www.drupal.org/project/workbench_moderation/issues/3054765
 */
function sec_workflow_post_update_add_taxonomy_moderation() {
  $definition_update_manager = \Drupal::entityDefinitionUpdateManager();
  /** @var \Drupal\Core\Entity\EntityLastInstalledSchemaRepositoryInterface $last_installed_schema_repository */
  $last_installed_schema_repository = \Drupal::service('entity.last_installed_schema.repository');
  $entity_type = $definition_update_manager->getEntityType('taxonomy_term');
  if (($fields = $last_installed_schema_repository->getLastInstalledFieldStorageDefinitions($entity_type->id())) && empty($fields['moderation_state'])) {
    $definition = BaseFieldDefinition::create('entity_reference')
      ->setLabel(t('Moderation state'))
      ->setDescription(t('The moderation state of this piece of content.'))
      ->setSetting('target_type', 'moderation_state')
      ->setRevisionable(TRUE)
      ->setTranslatable(TRUE)
      ->setDisplayOptions('view', [
        'label' => 'hidden',
        'type' => 'hidden',
        'weight' => -5,
      ])
      ->setDisplayOptions('form', [
        'type' => 'moderation_state_default',
        'weight' => 5,
        'settings' => [],
      ])
      ->addConstraint('ModerationState', [])
      ->setDisplayConfigurable('form', FALSE)
      ->setDisplayConfigurable('view', FALSE);
    $definition_update_manager->installFieldStorageDefinition('moderation_state', $entity_type->id(), 'workbench_moderation', $definition);
  }
}
