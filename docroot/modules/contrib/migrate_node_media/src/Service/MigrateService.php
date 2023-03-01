<?php

namespace Drupal\migrate_node_media\Service;

use Drupal\Core\Database\Connection;
use Drupal\media\Entity\Media;
use Drupal\migrate_node_media\Model\Map;
use Drupal\node\Entity\Node;

/**
 * Class MigrateService.
 *  Utility functions related to the migration/mappings.
 */
class MigrateService {

  /** @var \Drupal\Core\Database\Connection */
  protected $database;

  /**
   * MigrateService constructor.
   *
   * @param \Drupal\Core\Database\Connection $database
   */
  public function __construct(Connection $database) {
    $this->database = $database;
  }

  /**
   * Create a media entity based on the data from the node according to how the
   *  user created the mapping.
   *
   * @param \Drupal\migrate_node_media\Model\Map $map
   * @param $node
   *
   * @throws \Drupal\Core\Entity\EntityStorageException
   *
   * @return \Drupal\Core\Entity\EntityInterface
   */
  public static function createMediaEntity(Map $map, Node $node) {
    // Setup the media data array for the values to be saved to the media type
    $media_field_data = [];

    // Set the media bundle to the media type selected in the map
    $media_field_data['bundle'] = $map->getMediaType();

    // Go over the mapping fields and check the blacklist. Set any fields that
    //  are mapped.
    foreach ($map->getMappings() as $content_type_field => $media_field) {
      // Check to see that the field is set for mapping and that it's not part of
      //  the blacklist.
      //  @todo use the Map's blacklist
      if ($media_field !== 0 && $content_type_field !== "uuid" && $content_type_field !== "vid") {

        // Set the mapped media field value to the node's mapped field value
        $media_field_data[$media_field] = $node->get($content_type_field)
          ->getValue();
      }
    }

    // Create a new media entity with the data we pulled from the node
    $media_entity = Media::create($media_field_data);

    // Save the media entity to the DB
    $media_entity->save();

    // Return media entity
    return $media_entity;
  }
}
