<?php

/**
 * @file
 * Provides views data for the entity_reference_revisions module.
 */

use Drupal\Core\Entity\FieldableEntityInterface;
use Drupal\Core\Entity\Sql\SqlEntityStorageInterface;
use Drupal\field\FieldStorageConfigInterface;

/**
 * Implements hook_views_data().
 *
 * Adds relationships for entity_reference_revisions base fields.
 *
 * @todo remove this when https://www.drupal.org/node/2337515 is in.
 */
function entity_reference_revisions_views_data() {
  $entity_type_manager = \Drupal::entityTypeManager();
  $entity_field_manager = \Drupal::service('entity_field.manager');

  // Get all entity_reference_revisions base fields.
  /** @var \Drupal\Core\Entity\EntityTypeInterface[] $entity_types */
  $entity_types = [];
  $sql_entity_types = [];
  $fields_all = [];
  // Ensure origin and target entity types are SQL.
  foreach ($entity_type_manager->getDefinitions() as $entity_type) {
    if ($entity_type->hasHandlerClass('views_data') && $entity_type_manager->getStorage($entity_type->id()) instanceof SqlEntityStorageInterface) {
      $sql_entity_types[$entity_type->id()] = $entity_type->id();
      // Only fieldable entities have base fields.
      if ($entity_type->entityClassImplements(FieldableEntityInterface::CLASS)) {
        $entity_types[$entity_type->id()] = $entity_type;
        /** @var \Drupal\Core\Field\FieldDefinitionInterface $base_field */
        foreach ($entity_field_manager->getBaseFieldDefinitions($entity_type->id()) as $base_field) {
          if ($base_field->getType() == 'entity_reference_revisions') {
            $fields_all[$entity_type->id()][] = $base_field;
          }
        }
      }
    }
  }

  $data = [];
  foreach ($fields_all as $entity_type_id => $fields) {
    /** @var \Drupal\Core\Entity\Sql\DefaultTableMapping $table_mapping */
    $table_mapping = $entity_type_manager->getStorage($entity_type_id)->getTableMapping();

    $entity_type = $entity_types[$entity_type_id];
    $base_table = $entity_type->getDataTable() ?: $entity_type->getBaseTable();

    /** @var \Drupal\Core\Field\BaseFieldDefinition[] $fields */
    foreach ($fields as $field) {
      // Add a relationship to the target entity type.
      $target_entity_type_id = $field->getSettings()['target_type'];
      $target_entity_type = $entity_type_manager->getDefinition($target_entity_type_id);
      $entity_type_id = $field->getTargetEntityTypeId();
      $entity_type = $entity_type_manager->getDefinition($entity_type_id);
      $field_name = $field->getName();
      // Unlimited (-1) or > 1 store field data in a dedicated table.
      $table = $field->getCardinality() == 1 ? $base_table : $entity_type->getBaseTable() . '__' . $field_name;
      $target_table = $target_entity_type->getDataTable() ?: $target_entity_type->getBaseTable();

      foreach (['id' => 'id', 'revision' => 'revision_id'] as $key => $column) {
        if ($key == 'id' || !$target_entity_type->isRevisionable()) {
          $target_base_table = $target_entity_type->getDataTable() ?: $target_entity_type->getBaseTable();
        }
        else {
          $target_base_table = $target_entity_type->getRevisionDataTable() ?: $target_entity_type->getRevisionTable();
        }

        // Provide a relationship for the entity type with the entity reference
        // revisions field.
        $args = [
          '@label' => $target_entity_type->getLabel(),
          '@field_name' => $field_name,
        ];
        $relationship_field = $field->getCardinality() == 1 ? $field_name . '__target_' . $column : $field_name . '_target_' . $column;
        $data[$table][$field_name . '_target_' . $column]['relationship'] = [
          'title' => $key == 'id' ? t('@label referenced from @field_name', $args) : t('@label revision referenced from @field_name', $args),
          'label' => $key == 'id' ? t('@field_name: @label', $args) : t('@field_name: @label revision', $args),
          'group' => $entity_type->getLabel(),
          'help' => t('Base field, appears in all bundles'),
          'id' => 'standard',
          'base' => $target_base_table,
          'entity type' => $target_entity_type_id,
          'base field' => $target_entity_type->getKey($key),
          'relationship field' => $relationship_field,
        ];

        if ($key == 'id' || !$entity_type->isRevisionable()) {
          $base_table = $entity_type->getDataTable() ?: $entity_type->getBaseTable();
        }
        else {
          $base_table = $entity_type->getRevisionDataTable() ?: $entity_type->getRevisionTable();
        }

        // Provide a reverse relationship for the entity type that is referenced
        // by the entity reference revisions field.
        $args['@entity'] = $entity_type->getLabel();
        $args['@label'] = $target_entity_type->getSingularLabel();
        $pseudo_field_name = 'reverse__' . $entity_type_id . '__' . $field_name . '_target_' . $column;
        if ($field->getCardinality() == 1) {
          $field_data = [
            'id' => 'standard',
            'base field' => $field_name . '__target_' . $column,
            'field' => $target_entity_type->getKey('id'),
          ];
        }
        else {
          $field_data = [
            'id' => $key == 'id' ? 'entity_reverse' : 'entity_reference_revisions',
            'entity_type' => $entity_type_id,
            'base field' => $entity_type->getKey('id'),
            'field_name' => $field_name,
            'field table' => $key == 'id' ? $table_mapping->getDedicatedDataTableName($field) : $table_mapping->getDedicatedRevisionTableName($field),
            'field field' => $field_name . '_target_' . $column,
            'join_extra' => [
              [
                'field' => 'deleted',
                'value' => 0,
                'numeric' => TRUE,
              ],
            ],
          ];
        }
        $data[$target_table][$pseudo_field_name]['relationship'] = [
            'title' => $key == 'id' ? t('@entity using @field_name', $args) : t('@entity revision using @field_name', $args),
            'label' => $key == 'id' ? t('@field_name', ['@field_name' => $field_name]) : t('@field_name revision', ['@field_name' => $field_name]),
            'group' => $target_entity_type->getLabel(),
            'help' => $key == 'id' ? t('Relate each @entity with a @field_name set to the @label.', $args) : t('Relate each @entity revision with a @field_name set to the @label.', $args),
            'base' => $base_table,
          ] + $field_data;
      }
    }
  }

  return $data;
}

/**
 * Implements hook_field_views_data().
 */
function entity_reference_revisions_field_views_data(FieldStorageConfigInterface $field_storage) {
  $data = views_field_default_views_data($field_storage);
  $entity_manager = \Drupal::entityTypeManager();

  // Add a relationship to the target entity type.
  $target_entity_type_id = $field_storage->getSetting('target_type');
  $target_entity_type = $entity_manager->getDefinition($target_entity_type_id);
  $entity_type_id = $field_storage->getTargetEntityTypeId();
  $entity_type = $entity_manager->getDefinition($entity_type_id);
  $field_name = $field_storage->getName();
  /** @var \Drupal\Core\Entity\Sql\DefaultTableMapping $table_mapping */
  $table_mapping = $entity_manager->getStorage($entity_type_id)->getTableMapping();

  foreach ($data as $table_name => $table_data) {
    $target_base_table = $target_entity_type->getDataTable() ?: $target_entity_type->getBaseTable();

    // Provide a relationship for the entity type with the entity reference
    // revisions field.
    $args = [
      '@label' => $target_entity_type->getLabel(),
      '@field_name' => $field_name,
    ];
    $data[$table_name][$field_name]['relationship'] = [
      'title' => t('@label referenced from @field_name', $args),
      'label' => t('@field_name: @label', $args),
      'group' => $entity_type->getLabel(),
      'help' => t('Appears in: @bundles.', ['@bundles' => implode(', ', $field_storage->getBundles())]),
      'id' => 'standard',
      'base' => $target_base_table,
      'entity type' => $target_entity_type_id,
      'base field' => $target_entity_type->getKey('revision'),
      'relationship field' => $field_name . '_target_revision_id',
    ];

    // Provide a reverse relationship for the entity type that is referenced by
    // the field.
    $args['@entity'] = $entity_type->getLabel();
    $args['@label'] = $target_entity_type->getSingularLabel();
    $pseudo_field_name = 'reverse__' . $entity_type_id . '__' . $field_name;
    $data[$target_base_table][$pseudo_field_name]['relationship'] = [
      'title' => t('@entity using @field_name', $args),
      'label' => t('@field_name', ['@field_name' => $field_name]),
      'group' => $target_entity_type->getLabel(),
      'help' => t('Relate each @entity with a @field_name set to the @label.', $args),
      'id' => 'entity_reverse',
      'base' => $entity_type->getDataTable() ?: $entity_type->getBaseTable(),
      'entity_type' => $entity_type_id,
      'base field' => $entity_type->getKey('revision'),
      'field_name' => $field_name,
      'field table' => $table_mapping->getDedicatedDataTableName($field_storage),
      'field field' => $field_name . '_target_revision_id',
      'join_extra' => [
        [
          'field' => 'deleted',
          'value' => 0,
          'numeric' => TRUE,
        ],
      ],
    ];

    foreach (['id' => 'id', 'revision' => 'revision_id'] as $key => $column) {
      if ($key == 'id' || !$target_entity_type->isRevisionable()) {
        $target_base_table = $target_entity_type->getDataTable() ?: $target_entity_type->getBaseTable();
      }
      else {
        $target_base_table = $target_entity_type->getRevisionDataTable() ?: $target_entity_type->getRevisionTable();
      }

      // Provide a relationship for the entity type with the entity reference
      // revisions field.
      $args = [
        '@label' => $target_entity_type->getLabel(),
        '@field_name' => $field_name,
      ];
      $data[$table_name][$field_name . '_target_' . $column]['relationship'] = [
        'title' => $key == 'id' ? t('@label referenced from @field_name', $args) : t('@label revision referenced from @field_name', $args),
        'label' => $key == 'id' ? t('@field_name: @label', $args) : t('@field_name: @label revision', $args),
        'group' => $entity_type->getLabel(),
        'help' => t('Appears in: @bundles.', ['@bundles' => implode(', ', $field_storage->getBundles())]),
        'id' => 'standard',
        'base' => $target_base_table,
        'entity type' => $target_entity_type_id,
        'base field' => $target_entity_type->getKey($key),
        'relationship field' => $field_name . '_target_' . $column,
      ];

      if ($key == 'id' || !$entity_type->isRevisionable()) {
        $base_table = $entity_type->getDataTable() ?: $entity_type->getBaseTable();
      }
      else {
        $base_table = $entity_type->getRevisionDataTable() ?: $entity_type->getRevisionTable();
      }

      // Provide a reverse relationship for the entity type that is referenced
      // by the field.
      $args['@entity'] = $entity_type->getLabel();
      $args['@label'] = $target_entity_type->getSingularLabel();
      $pseudo_field_name = 'reverse__' . $entity_type_id . '__' . $field_name . '_target_' . $column;
      $data[$target_base_table][$pseudo_field_name]['relationship'] = [
        'title' => $key == 'id' ? t('@entity using @field_name', $args) : t('@entity revision using @field_name', $args),
        'label' => $key == 'id' ? t('@field_name', ['@field_name' => $field_name]) : t('@field_name revision', ['@field_name' => $field_name]),
        'group' => $target_entity_type->getLabel(),
        'help' => $key == 'id' ? t('Relate each @entity with a @field_name set to the @label.', $args) : t('Relate each @entity revision with a @field_name set to the @label.', $args),
        'id' => $key == 'id' ? 'entity_reverse' : 'entity_reference_revisions',
        'base' => $base_table,
        'entity_type' => $entity_type_id,
        'base field' => $entity_type->getKey($key),
        'field_name' => $field_name,
        'field table' => $key == 'id' ? $table_mapping->getDedicatedDataTableName($field_storage) : $table_mapping->getDedicatedRevisionTableName($field_storage),
        'field field' => $field_name . '_target_' . $column,
        'join_extra' => [
          [
            'field' => 'deleted',
            'value' => 0,
            'numeric' => TRUE,
          ],
        ],
      ];
    }
  }

  return $data;
}
