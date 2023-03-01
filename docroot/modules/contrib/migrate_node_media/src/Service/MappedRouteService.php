<?php

namespace Drupal\migrate_node_media\Service;

use Drupal\Core\Database\Connection;
use Drupal\migrate_node_media\Model\MappedRoute;

/**
 * Class MappedRouteService.
 *  Utility functions related to the migration/mappings.
 *
 * @todo Perhaps create a map service separate from the migrate service
 */
class MappedRouteService {

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
   * Adds a new mapped route to the database.
   *
   * @param \Drupal\migrate_node_media\Model\MappedRoute $mapped_route
   *
   * @return bool|\Drupal\Core\Database\StatementInterface|int|null
   * @throws \Exception
   */
  public function create(MappedRoute $mapped_route) {
    // Setup the insert query and JSON encode the mappings so we can decode it
    //  later when we pull it out of the database
    $query = $this->database->insert('migrate_node_media_route');
    $query->fields([
      'nid' => $mapped_route->getNid(),
      'mid' => $mapped_route->getMid(),
      'content_route' => $mapped_route->getContentRoute(),
      'media_route'   => $mapped_route->getMediaRoute(),
      'map_id'        => $mapped_route->getMapId(),
    ]);

    // Add the mapped route record
    return $query->execute();
  }

  /**
   * Gets all of the mapped routes from the database.
   *
   * @return bool|mixed
   */
  public function getAll() {
    // Get all the mapped routes by sending no values to the method
    return $this->getById();
  }

  public function getJSON($map_id) {
    $mappings = $this->getById($map_id);
    $mapped_routes_array = [];
    foreach ($mappings as $route) {
      $mapped_routes_array[] = $mappings;

    }
    return $mapped_routes_array;
  }

  public function getByMap(int $map_id = NULL, bool $reset = FALSE) {
    // Setup the table to pull the data from
    $query = $this->database->select('migrate_node_media_route');

    // Grab these specific fields
    $query->fields('migrate_node_media_route',
      ['id', 'content_route', 'media_route', 'map_id', 'nid', 'mid']);

    // If an id was set, add a condition to match that id
    if ($map_id) {
      $query->condition('map_id', $map_id);
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
   * Gets a mapping from the database.
   *
   * If no parameters are set, all mappings are pulled. If an id is set, then
   *  grab that particular mapping.
   *
   * @param integer $id
   * @param bool $reset
   *
   * @return bool|mixed
   */
  public function getById(int $id = NULL, bool $reset = FALSE) {
    // Setup the table to pull the data from
    $query = $this->database->select('migrate_node_media_route');

    // Grab these specific fields
    $query->fields('migrate_node_media_route',
      ['id', 'content_route', 'media_route', 'map_id']);

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
   * @return \Drupal\migrate_node_media\Model\MappedRoute
   */
  function getMappedRoute(int $id): MappedRoute {
    // Grab the mapped route from the database
    $data = $this->getById($id)[0];

    // Create a new map with fields from the database
    $mapped_route = new MappedRoute($data->content_route, $data->media_route);

    // Add the ID since this is an existing map
    $mapped_route->setId($data->id);

    // Send the map
    return $mapped_route;
  }
}
