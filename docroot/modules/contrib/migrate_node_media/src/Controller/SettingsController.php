<?php

namespace Drupal\migrate_node_media\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Entity\EntityStorageException;
use Drupal\migrate_node_media\Model\MappedRoute;
use Drupal\migrate_node_media\Service\MigrateService;
use Drupal\migrate_node_media\Service\SettingsService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class SettingsController.
 */
class SettingsController extends ControllerBase {

  /**
   * Main Page. List of mappings.
   *
   * @return array
   */
  public function index() {
    // Service loading.
    /** @var \Drupal\migrate_node_media\Service\MappingService $mapping_service */
    $mapping_service = \Drupal::service('migrate_node_media.mapping');

    // Get all the mappings
    $data = $mapping_service->getAll();

    // Send the data to the theme and handle it with Twig in:
    //  templates/migrate-node-media.html.twig
    return [
      '#theme' => 'migrate_node_media',
      '#data'  => $data,
    ];
  }

  /**
   * JSON Output for Content Types.
   *
   * @return array
   */
  public function json() {

    // Grab the JSON API Menu
    $output = $this->getJSONAPIMenu();

    // No theme, just output
    return [
      '#type'   => 'markup',
      '#markup' => $output,
    ];
  }

  /**
   * Build the JSON API menu.
   *
   * @return string
   */
  private function getJSONAPIMenu(): string {
    // Service loading.
    /** @var \Drupal\migrate_node_media\Service\MappedRouteService $mapped_route_service */
    $mapped_route_service = \Drupal::service('migrate_node_media.route');

    /** @var \Drupal\migrate_node_media\Service\MappingService $mapping_service */
    $mapping_service = \Drupal::service('migrate_node_media.mapping');

    // Get all the mappings
    //$mapped_routes = $mapped_route_service->getAll();

    // Start building up some of the HTML maybe I should let template take care
    //  of it.
    // @todo Make this into a template
    $output = "<h1>JSON Output</h1>";
    $output .= "<ul>";

    // Create a link for each of the content types
    foreach (SettingsService::getJSONAPILinks() as $link) {
      $output .= "<li>$link</li>";
    }
    $output .= "</ul>";

    // Get Mappings Links
    $output .= "<h1>Routes JSON Output</h1>";
    $output .= "<ul>";
    foreach ($mapping_service->getAll() as $map) {
      $output .= "<li><a href='/admin/config/migrate/node_media/routes/json/" . $map->id . "'>" . $map->name . "</a></li>";
    }
    $output .= "</ul>";

    // Complete HTML output
    return $output;
  }

  /**
   * Route for JSON endpoints e.g. /admin/config/migrate/node_media/json/article
   *
   * @param string $type
   * @param \Symfony\Component\HttpFoundation\Request $request
   *
   * @return \Symfony\Component\HttpFoundation\JsonResponse
   */
  public function json_api(string $type, Request $request) {
    // Setting up to be able to serialize to JSON
    /** @var \Symfony\Component\Serializer\Serializer $serializer */
    $serializer = \Drupal::service('serializer');

    // Grabbing all the nodes of the requested content type
    $nodes = SettingsService::getAllContentOfType($type);

    $data = $this->build_custom_json_output($nodes);

    // Serializing all the nodes to JSON
    //$data = $serializer->serialize($nodes_array, 'json', ['plugin_id' => 'entity']);
    //$data = json_encode($nodes_array);
    // Setting up the response output with the JSON data and the method
    // @todo Change the output to just the node data and not have the data & method
    $response['data'] = $data;
    $response['method'] = 'GET';

    // Send back the JSON response
    $json_response = new JsonResponse();
    $json_response->setJson($data);
    return $json_response;
  }

  public function route_json(string $map_id, Request $request) {
    // Service loading.
    /** @var \Drupal\migrate_node_media\Service\MappedRouteService $mapped_route_service */
    $mapped_route_service = \Drupal::service('migrate_node_media.route');

    // Get all the mappings
    $data = $mapped_route_service->getByMap($map_id);
    $json_serialized_data = json_encode($data);

    // Send back the JSON response
    $json_response = new JsonResponse();
    $json_response->setJson($json_serialized_data);
    return $json_response;

  }

  public function build_custom_json_output($nodes) {
    $nodes_array = [];
    /** @var \Drupal\node\Entity\Node $node */
    foreach($nodes as $node) {
      $obj = new \stdClass();
      $obj->nid = $node->get('nid')->getValue()[0]['value'];
      $obj->title = $node->get('title')->getValue()[0]['value'];
      $obj->content_path = '/node/' . $obj->nid;
      $obj->media_path = '/media/' . '5';
      $nodes_array[] = $obj;
    }

    return json_encode($nodes_array);
  }

  /**
   * Route for Migrations page e.g. /admin/config/migrate/node_media/migrate.
   *
   * @return array
   */
  public function migrate() {
    // Build up the default HTML for the migrations page, provide example links
    // @todo Remove this output and add in list of migrations
    $output = "<h1>Migrations</h1>";
    $output .= "<a href='/admin/config/migrate/node_media/migrate/article/file'>Run Article to File Migration</a>";

    // No theme, just output
    return [
      '#type'   => 'markup',
      '#markup' => $output,
    ];
  }

  /**
   * Route that handles the data migration.
   *
   * For example, the path: /admin/config/migrate/node_media/migrate/1 runs the
   *  migration for the map of id 1.
   *
   * @param $map_id
   *
   * @return array|bool
   */
  public function migrate_data($map_id) {
    $output = SettingsService::runMigration($map_id);

    // No theme, just output
    return [
      '#type'   => 'markup',
      '#markup' => $output,
    ];
  }

  /**
   * Migrated Routes List.
   *
   * @return array
   */
  public function routes() {
    // Service loading.
    /** @var \Drupal\migrate_node_media\Service\MappedRouteService $mapped_route_service */
    $mapped_route_service = \Drupal::service('migrate_node_media.route');

    // Get all the mappings
    $data = $mapped_route_service->getAll();

    // Send the data to the theme and handle it with Twig in:
    //  templates/migrate-node-media.html.twig
    return [
      '#theme' => 'migrate_node_media_route',
      '#data'  => $data,
    ];
  }

}
