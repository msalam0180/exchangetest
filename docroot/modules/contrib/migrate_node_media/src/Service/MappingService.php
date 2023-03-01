<?php

namespace Drupal\migrate_node_media\Service;

use Drupal\Core\Database\Connection;
use Drupal\media\Entity\Media;
use Drupal\migrate_node_media\Model\Map;
use Drupal\node\Entity\Node;

/**
 * Class MigrateService.
 *  Utility functions related to the migration/mappings.
 *
 * @todo Perhaps create a map service separate from the migrate service
 */
class MappingService {

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
   * Adds a new mapping to the database.
   *
   * @param \Drupal\migrate_node_media\Model\Map $map
   *
   * @return bool|\Drupal\Core\Database\StatementInterface|int|null
   * @throws \Exception
   */
  public function create(Map $map) {
    // See if the map has the fields we expect and if not then return
    if (empty($map->getName()) || empty($map->getContentType()) || empty($map->getMediaType())) {
      return FALSE;
    }

    // Setup the insert query and JSON encode the mappings so we can decode it
    //  later when we pull it out of the database
    $query = $this->database->insert('migrate_node_media');
    $query->fields([
      'name'         => $map->getName(),
      'content_type' => $map->getContentType(),
      'media_type'   => $map->getMediaType(),
      'mapping'      => json_encode($map->getMappings()),
    ]);

    // Add the map record
    return $query->execute();
  }

  /**
   * Gets all of the mappings from the database.
   *
   * @return bool|mixed
   */
  public function getAll() {
    // Get all the maps by sending no values to the method
    return $this->getById();
  }

  /**
   * Gets a mapping from the database.
   *
   * If no parameters are set, all mappings are pulled. If an id is set, then
   *  grab that particular mapping.
   *
   * @param null $id
   * @param bool $reset
   *
   * @return bool|mixed
   */
  public function getById($id = NULL, $reset = FALSE) {
    // Setup the table to pull the data from
    $query = $this->database->select('migrate_node_media');

    // Grab these specific fields
    $query->fields('migrate_node_media',
      ['id', 'name', 'content_type', 'media_type', 'mapping']);

    // If an id was set, add a condition to match that id
    if ($id) {
      $query->condition('id', $id);
    }

    // Grab all of the results from the DB
    $result = $query->execute()->fetchAll();

    // If we have a result then return it
    if (count($result)) {
      // But first let's see if the user passed in the reset flag
      if ($reset) {
        $result = reset($result);
      }

      // Send the results
      return $result;
    }

    // Something failed, return false
    return FALSE;
  }

  /**
   * Get a particular mapping and build the object.
   *
   * @param integer $id
   *
   * @return \Drupal\migrate_node_media\Model\Map
   */
  function getMap(int $id): Map {
    // Grab the mapping data from the database
    $data = $this->getById($id)[0];

    // Create a new map with fields from the database
    $map = new Map($data->name, $data->content_type, $data->media_type);

    // Add the ID since this is an existing map
    $map->setId($data->id);

    // Decode the JSON of the mappings and set the mappings
    $map->setMappings(json_decode($data->mapping, TRUE));

    // Send the map
    return $map;
  }
}
