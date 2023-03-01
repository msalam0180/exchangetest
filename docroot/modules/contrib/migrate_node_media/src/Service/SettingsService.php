<?php

namespace Drupal\migrate_node_media\Service;

use Drupal\Component\Plugin\Exception\InvalidPluginDefinitionException;
use Drupal\Component\Plugin\Exception\PluginNotFoundException;
use Drupal\Core\Entity\EntityStorageException;
use Drupal\migrate_node_media\Model\MappedRoute;
use Drupal\redirect\Entity\Redirect;

/**
 * Class SettingsService.
 */
abstract class SettingsService {

  public static function runMigration(int $map_id): string {
    // Load in the mapping service using Drupal's service because we need to
    //  automatically pass in database information
    /** @var \Drupal\migrate_node_media\Service\MappingService $mapping_service */
    $mapping_service = \Drupal::service('migrate_node_media.mapping');

    /** @var \Drupal\migrate_node_media\Service\MappedRouteService $mapped_route_service */
    $mapped_route_service = \Drupal::service('migrate_node_media.route');

    // Get the map from the database for the specified id
    /** @var \Drupal\migrate_node_media\Model\Map $map */
    $map = $mapping_service->getMap($map_id);

    // Get all of the nodes for the specified content type from the map
    $nodes = SettingsService::getAllContentOfType($map->getContentType());

    // Create a media entity for each one of the nodes
    /** @var \Drupal\node\Entity\Node $node */
    foreach ($nodes as $node) {
      try {
        // Create the Media Entity
        $media_entity = MigrateService::createMediaEntity($map, $node);

        // Setup a new mapped route
        $mapped_route = new MappedRoute($node->id(),
          $media_entity->id(), $map->getId());

        // Save mapped route to the mapped routes array
        try {
          $mapped_route_service->create($mapped_route);
        } catch (\Exception $e) {
          echo 'Could not save mapped route: ', $e->getMessage(), "\n";
          return FALSE;
        }

        // Setup a new redirect
        $redirectEntityManager = \Drupal::service('entity.manager')->getStorage('redirect');

        /** @var \Drupal\redirect\Entity\Redirect $redirect */
        $redirect = $redirectEntityManager->create();

        $redirect->setSource('/node/' . $node->id());
        $redirect->setRedirect('/media/' . $media_entity->id());
        $redirect->setStatusCode(301);
        $redirect->save();

      } catch (EntityStorageException $e) {
        echo 'Could not create media entity: ', $e->getMessage(), "\n";
        return FALSE;
      }
    }
    $number_of_nodes_processed = count($nodes);
    $content_type = $map->getContentType();
    $media_type = $map->getMediaType();
    $output = "<h1>Migrated $number_of_nodes_processed $content_type node(s) to Media type: $media_type</h1>";

    return $output;
  }


  /**
   * Grabs all of the content types e.g. Article, Blog.
   *
   * @return bool|\Drupal\Core\Entity\EntityInterface[]
   */
  public static function getMediaTypes() {
    // Ask Drupal to kindly give us all types of media entities
    try {
      $media_types = \Drupal::entityTypeManager()
        ->getStorage('media_type')
        ->loadMultiple();
    } catch (InvalidPluginDefinitionException $e) {
      echo 'Invalid Plugin Definition: ', $e->getMessage(), "\n";
      return FALSE;
    } catch (PluginNotFoundException $e) {
      echo 'Plugin Not Found: ', $e->getMessage(), "\n";
      return FALSE;
    }

    // Return the media types
    return $media_types;
  }

  /**
   * Retrieves all content of the given content type.
   *
   * @param string $type
   *
   * @return array
   */
  public static function getAllContentOfType(string $type): array {
    // Get all of the nids of the given type
    $node_ids = \Drupal::entityQuery('node')
      ->condition('type', $type)
      ->execute();

    // Use the nids to load all of those nodes
    $nodes = \Drupal\node\Entity\Node::loadMultiple($node_ids);

    // If we have some nodes, return them
    if (!empty($nodes)) {
      return $nodes;
    }

    // If we don't have any nodes, return an empty array to adhere to the return
    //  value.
    return [];
  }

  /**
   * Grab all of the fields of the given content type.
   *
   * @param string $bundle
   *
   * @return mixed
   */
  public static function getContentTypeFields(string $bundle) {
    // Load up the entity field manager service
    $entity_field_manager = \Drupal::service('entity_field.manager');

    // Grab the fields for the given content type
    $content_type_fields = $entity_field_manager->getFieldDefinitions('node',
      $bundle);

    // Send the fields
    return $content_type_fields;
  }

  /**
   * Get all of the fields for the given media type.
   *
   * @param string $bundle
   *
   * @return \Drupal\Core\Field\FieldDefinitionInterface[]
   */
  public static function getMediaTypeFields(string $bundle) {
    // Load up the entity field manager service
    /** @var  \Drupal\Core\Entity\EntityFieldManagerInterface $entity_field_manager */
    $entity_field_manager = \Drupal::service('entity_field.manager');

    // Grab the fields for the given content type
    $media_fields = $entity_field_manager->getFieldDefinitions('media',
      $bundle);

    // Send the fields
    return $media_fields;
  }

  /**
   * Builds JSON API links for all of the content types.
   *
   * @return array
   */
  public static function getJSONAPILinks(): array {
    // Get all of the content types
    $content_types = SettingsService::getContentTypes();

    // Setup the output array
    $output = [];

    // Create a URL / Link for every content type to it's respective JSON route
    foreach ($content_types as $content_type => $type_data) {
      // Build the JSON link for the content type
      $output[] = "<a href='/admin/config/migrate/node_media/json/$content_type' target='_blank'>$content_type</a>";
    }

    // Send the list of links
    return $output;
  }

  /**
   * Returns a list of all the content types.
   *
   * @return bool|\Drupal\Core\Entity\EntityInterface[]
   */
  public static function getContentTypes() {
    // Grab the content types
    try {
      $content_types = \Drupal::entityTypeManager()
        ->getStorage('node_type')
        ->loadMultiple();
    } catch (InvalidPluginDefinitionException $e) {
      echo 'Invalid Plugin Definition: ', $e->getMessage(), "\n";
      return FALSE;
    } catch (PluginNotFoundException $e) {
      echo 'Plugin not found: ', $e->getMessage(), "\n";
      return FALSE;
    }

    // Send the list of types
    return $content_types;
  }
}
