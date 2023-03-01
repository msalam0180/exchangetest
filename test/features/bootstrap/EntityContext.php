<?php
/**
 * @file
 * Contains \EntitySubContext.
 */

use Behat\Gherkin\Node\TableNode;
use Behat\Mink\Exception\ExpectationException;
use Drupal\Core\Entity\EntityInterface;
use Drupal\DrupalExtension\Context\DrupalContext;
use Drupal\DrupalExtension\Context\DrupalSubContextBase;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Hook\Scope\EntityScope;
use Drupal\field\Entity\FieldStorageConfig;
use Drupal\field\Entity\FieldConfig;
use Drupal\node\Entity\Node;
use Drupal\core\Entity;
use Drupal\taxonomy\Entity\Term;
use Drupal\user\Entity\User;
use Drupal\menu_link_content\Entity\MenuLinkContent;
use Drupal\file\Entity\File;

/**
 * Subcontext for creating and cleaning up entities of any type.
 */
class EntityContext extends RawDrupalContext {
  /**
   * Entities created during the scenario, organized by type.
   *
   * @var array
   */
  protected $entities = [];

  /**
   * Ensures the Drupal driver is bootstrapped.
   *
   * @throws \RuntimeException
   *   If the Drupal driver is not bootstrapped.
   */
  protected function ensureBootstrap() {
    if ($this->getDriver()->isBootstrapped() == FALSE) {
      throw new \RuntimeException('Drupal is not bootstrapped.');
    }
  }

  /**
   * Creates menu.
   * | KEY  | name | field_color  | field_reference_name  |
   * | Blue | Blue | 0000FF       | text key              |
   * | ...  | ...  | ...          | ...                   |
   *
   * @Given I create menu:
   */
  public function iCreateMenu(TableNode $table) {
    $this->createEntities('menu', $table->getHash(), NULL);
  }

  /**
   * Creates entity of given entity type and bundle.
   * | KEY  | name | field_color  | field_reference_name  |
   * | Blue | Blue | 0000FF       | text key              |
   * | ...  | ...  | ...          | ...                   |
   *
   * @Given I create :entity_type of type :bundle:
   */
  public function iCreateEntity($entity_type, $bundle, TableNode $table) {
    return $this->createEntities($entity_type, $table->getHash(), $bundle);
  }

  protected function createNodes($type, TableNode $nodesTable) {
    foreach ($nodesTable->getHash() as $nodeHash) {
      $node = (object)$nodeHash;
      $node->type = $type;
      $this->nodeCreate($node);
    }
  }

  /**
   * Creates entity of given entity type and bundle.
   * | KEY                   | Blue     | ... |
   * | name                  | Blue     | ... |
   * | field_color           | 0000FF   | ... |
   * | field_reference_name  | text key | ... |
   *
   * @Given I create large :entity_type of type :bundle:
   */
  public function iCreateLargeEntity($entity_type, $bundle, TableNode $table) {
    $this->createEntities($entity_type, $this->getColumnHashFromRows($table), $bundle);
  }

  /**
   * Create Keyed Entities
   *
   * @param $entity_type string
   *   Entity type id.
   * @param $bundle string
   *   Bundle type id.
   * @param $hash array
   *   Table hash
   *
   * @return array
   *   Saved entities.
   */
  protected function createEntities($entity_type, $hash, $bundle = "") {
    $saved = [];
    foreach ($hash as $entity_hash) {
      $entity_storage = \Drupal::entityTypeManager()->getStorage($entity_type);
      $entity_storage_keys = $entity_storage->getEntityType()->getKeys();
      if (!empty($entity_storage_keys['bundle']) && is_string($entity_storage_keys['bundle'])) {
        $bundle_key = $entity_storage_keys['bundle'];
        $entity_hash[$bundle_key] = $bundle;
      }
      // Allow KEY as optional.
      $entity_key = NULL;
      if (!empty($entity_hash['KEY'])) {
        $entity_key = $entity_hash['KEY'];
        unset($entity_hash['KEY']);
      }

      if (isset($entity_hash['field_start_date'])) {
        $date = new DateTime($entity_hash['field_start_date'], new DateTimeZone("America/New_York"));
        $entity_hash['field_start_date'] = $date->format('Y-m-d\TH:i:s');
      }

      if (isset($entity_hash['field_end_date'])) {
        $date = new DateTime($entity_hash['field_end_date'], new DateTimeZone("America/New_York"));
        $entity_hash['field_end_date'] = $date->format('Y-m-d\TH:i:s');
      }

      if (isset($entity_hash['field_publish_date'])) {
        $date = new DateTime($entity_hash['field_publish_date'], new DateTimeZone("America/New_York"));
        $entity_hash['field_publish_date'] = $date->format('Y-m-d\TH:i:s');
      }

      if (isset($entity_hash['published_at'])) {
        $date = new DateTime($entity_hash['published_at']);
        $entity_hash['published_at'] = $date->getTimestamp();
      }

      if (isset($entity_hash['created'])) {
        $date = new DateTime($entity_hash['created']);
        $entity_hash['created'] = $date->getTimestamp();
      }

      if (isset($entity_hash['changed'])) {
        $date = new DateTime($entity_hash['changed']);
        $entity_hash['changed'] = $date->getTimestamp();
      }

      if ($bundle) {
        $this->preProcessFields($entity_hash, $entity_type, $bundle);
        $entity_obj = (object)$entity_hash;
        $this->parseEntityFields($entity_type, $entity_obj);
        $stdEntity = $this->entityCreate($entity_type, $entity_obj);
        $entity =  \Drupal::entityTypeManager()->getStorage($entity_type)->load($stdEntity->id);
        $this->saveEntity($entity, $entity_key);
        $saved[] = $stdEntity;
      } else {
        $entity_obj = (object)$entity_hash;
        $entity = $entity_storage->create((array)$entity_obj);
        $entity->save();
        $saved[] = $entity;
        $this->saveEntity($entity, $entity_key);
      }


    }
    return $saved;
  }

    /**
   * @Given :entity_type entities:
   */
  public function createEntity($entity_type, TableNode $data) {
    $entity_storage = \Drupal::entityTypeManager()->getStorage($entity_type);
    foreach ($data->getHash() as $hash) {
      $values = array();
      foreach ($hash as $k => $v) {
        $values[$k] = $v;
      }
      $entity = $entity_storage->create($values);
      $entity->save();
      $this->entities[$entity_type][$entity->id()] = $entity;
    }
  }

  /**
   * Process fields from entity hash to allow referencing by key.
   *
   * @param $entity_hash array
   *   Array of field value pairs.
   * @param $entity_type string
   *   String entity type.
   */
  protected function processFields(&$entity_hash, $entity_type) {
    foreach ($entity_hash as $field_name => $field_value) {
      // Get field info.
      $fiend_info = FieldStorageConfig::loadByName($entity_type, $field_name);
      if ($fiend_info == NULL || !in_array(($field_type = $fiend_info->getType()), ['entity_reference', 'entity_reference_revisions', 'image'])) {
        continue;
      }
      // Explode field value on ', ' to get values/keys.
      $field_values = explode(', ', $field_value);
      unset($entity_hash[$field_name]);
      $target_id = [];
      $target_revision_id = [];
      foreach ($field_values as $value_or_key) {
        if ($field_type == 'image') {
          $file = File::create([
            'filename' => $value_or_key,
            'uri' => 'public://' . $value_or_key,
            'status' => 1,
          ]);
          $file->save();
          $this->saveEntity($file);
          $target_id[] = $file->id();
        } else {
          $entity_id = $this->getEntityIDByKey($value_or_key);
          if ($field_type == 'entity_reference') {
            // Set the target id.
            $target_id[] = $entity_id;
          } elseif ($field_type == 'entity_reference_revisions') {
            // Set the target id.
            $target_id[] = $entity_id;
            // Set target revision id.
            $target_revision_id[] = $entity_id;
          }
        }
      }
      if (!empty($target_id)) {
        $entity_hash[$field_name . ':target_id'] = implode(', ', $target_id);
      }
      if (!empty($target_revision_id)) {
        $entity_hash[$field_name . ':target_revision_id'] = implode(', ', $target_revision_id);
      }
    }
  }

  /**
   * Create test file from name, it may use a real file from the mink file_path.
   *
   * @param $file_name string
   *   A file name the may exist in the mink file_path folder.
   *
   * @return \Drupal\Core\Entity\EntityInterface|mixed|static
   *
   * @throws \Exception
   */
  public function createTestFile($file_name) {
    $file = str_replace('\\"', '"', $file_name);
    $file_destination = 'public://' . $file_name;
    $filesystem = \Drupal::service('file_system');

    if ($this->getMinkParameter('files_path')) {
      $file_path = rtrim(realpath($this->getMinkParameter('files_path')), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $file;
      if (is_file($file_path)) {
        if (!($file_destination = $filesystem->copy($file_path, $file_destination))) {
          $msg = 'File copy fail, "' . $file_path . '" to ' . $file_destination;
          throw new \Exception($msg);
        }
      }
    }
    $file = File::create([
      'filename' => $file_name,
      'uri' => $file_destination,
      'status' => 1,
    ]);
    $file->save();
    $this->saveEntity($file);
    return $file;
  }

  /**
   * Saves entity by entity key.
   *
   * @param $entity_key
   *   Entity key value.
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   Entity object.
   */
  protected function saveEntity(EntityInterface $entity, $entity_key = NULL) {
    $entity_type = $entity->getEntityTypeId();

    if ($entity_key != NULL) {
      $this->entities[$entity_type][$entity_key] = $entity;
    } else {
      $this->entities[$entity_type][] = $entity;
    }
  }

  /**
   * Process fields from entity hash to allow referencing by key.
   *
   * @param $entity_hash array
   *   Array of field value pairs.
   * @param $entity_type string
   *   String entity type.
   */
  protected function preProcessFields(&$entity_hash, $entity_type, $bundle) {
    foreach ($entity_hash as $field_name => $field_value) {
      // Get field info.
      $field_info = FieldConfig::loadByName($entity_type, $bundle, $field_name);
      if ($field_info == NULL || !in_array(($field_type = $field_info->getType()), ['entity_reference', 'entity_reference_revisions', 'image', 'file'])) {
        if (in_array($field_name, ['changed', 'created', 'revision_timestamp']) && !empty($field_value) && !is_numeric($field_value)) {
          $entity_hash[$field_name] = strtotime($field_value);
        }
        continue;
      }
      // Explode field value on ', ' to get values/keys.
      $field_values = explode(', ', $field_value);
      unset($entity_hash[$field_name]);
      $value_id = [];
      $target_revision_id = [];
      foreach ($field_values as $value_or_key) {
        if ($field_type == 'image' || $field_type == 'file') {
          $file = $this->createTestFile($value_or_key);
          $value_id[] = $file->label();
        } else {
          $entity_id = $this->getEntityIDByKey($value_or_key);
          $entity_revision_id = $this->getEntityRevisionIDByKey($value_or_key);
          if ($field_type == 'entity_reference') {
            $value_id[] = $field_value;
          } elseif ($field_type == 'entity_reference_revisions') {
            // Set target revision id.
            $target_id[] = $entity_id;
            $target_revision_id[] = $entity_revision_id;
          }
        }
      }
      if (!empty($value_id)) {
        $entity_hash[$field_name] = implode(', ', $value_id);
      }
      if (!empty($target_revision_id) && !empty($target_id)) {
        $entity_hash[$field_name . ':target_id'] = implode(', ', $target_id);
        $entity_hash[$field_name . ':target_revision_id'] = implode(', ', $target_revision_id);
      }
    }
  }

  /**
   * Creates a set of menu links.
   *
   * @param \Behat\Gherkin\Node\TableNode $table
   *   The entities to create.
   *
   * This may not be great--I'm just using nid 0 as a placeholder.
   *
   * @Given menu links:
   */
  public
  function createMenuLinks(TableNode $table) {
    $nid = 0;
    $this->ensureBootstrap();
    foreach ($table as $row) {
      $menu_link = MenuLinkContent::create([
        'title' => $row['title'],
        'link' => ['uri' => 'internal:/node/' . $nid],
        'menu_name' => $row['menu_name']
      ]);
      $menu_link->save();
    }
  }

  /**
   * Queues a node to be deleted at the end of the scenario.
   *
   * @param \Drupal\DrupalExtension\Hook\Scope\EntityScope $scope
   *   The hook scope.
   *
   * @afterNodeCreate
   */
  public
  function queueNode(EntityScope $scope) {
    $node = Node::load($scope->getEntity()->nid);
    $this->queueEntity($node);
  }

  /**
   * Queues a taxonomy term to be deleted at the end of the scenario.
   *
   * @param \Drupal\DrupalExtension\Hook\Scope\EntityScope $scope
   *   The hook scope.
   *
   * @afterTermCreate
   */
  public
  function queueTerm(EntityScope $scope) {
    $term = Term::load($scope->getEntity()->tid);
    $this->queueEntity($term);
  }

  /**
   * Queues a user to be deleted at the end of the scenario.
   *
   * @param \Drupal\DrupalExtension\Hook\Scope\EntityScope $scope
   *   The hook scope.
   *
   * @afterUserCreate
   */
  public
  function queueUser(EntityScope $scope) {
    $user = User::load($scope->getEntity()->uid);
    $this->queueEntity($user);
  }

  /**
   * Queues an entity to be deleted at the end of the scenario.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The entity to queue.
   */
  public
  function queueEntity(EntityInterface $entity) {
    $entity_type = $entity->getEntityTypeId();
    $this->entities[$entity_type][] = $entity;
  }

  /**
   * Deletes all entities created during the scenario.
   *
   * @AfterScenario
   */
  public
  function cleanEntities() {
    foreach ($this->entities as $entity_type => $entities) {
      /** @var \Drupal\Core\Entity\EntityInterface $entity */
      foreach ($entities as $entity) {
        // Clean up the entity's alias, if there is one.
        if ($entity_type != 'paragraph') {
          if (method_exists($entity, 'tourl')) {
            try {
              $path = '/' . $entity->toUrl()->getInternalPath();
              $alias = \Drupal::service('path.alias_manager')
                ->getAliasByPath($path);
              if ($alias != $path) {
                \Drupal::service('path.alias_storage')
                  ->delete(['alias' => $alias]);
              }
            } catch (Exception $e) {
              // do nothing
            }
          }
        }
      }
      $storage_handler = \Drupal::entityTypeManager()->getStorage($entity_type);
      // If this is a Multiversion-aware storage handler, call purge() to do a
      // hard delete.
      if (method_exists($storage_handler, 'purge')) {
        $storage_handler->purge($entities);
      } else {
        $storage_handler->delete($entities);
      }
    }
  }

  /**
   * Get entity by key from created test scenario entities.
   *
   * @param $key string
   *   Key string
   *
   * @return mixed|\Drupal\Core\Entity\EntityInterface
   *   Entity.
   *
   * @throws \Exception
   */
  protected
  function getEntityByKey($key) {
    foreach ($this->entities as $entities) {
      if (!empty($entities[$key])) {
        return $entities[$key];
      }

      foreach ($entities as $entity) {
        if (method_exists($entity, 'getName') && $entity->getName() == $key) {
          return $entity;
        }
      }
    }
    //$msg = 'Key "' . $key . '" does not match existing entity key';
    //throw new \Exception($msg);
    return FALSE;
  }

  /**
   * Get entity id by key.
   *
   * @param $key string
   *   Key string to lookup saved entity.
   * @return mixed
   *   Entity id.
   */
  protected
  function getEntityIDByKey($key) {
    /* @var \Drupal\Core\Entity\EntityInterface $entity */
    if (($entity = $this->getEntityByKey($key)) != NULL) {
      return $entity->id();
    }
    return FALSE;
  }

  /**
   * Get entity revision id by key.
   *
   * @param $key string
   *   Key string to lookup saved entity.
   * @return mixed
   *   Entity revision id.
   */
  protected
  function getEntityRevisionIDByKey($key) {
    /* @var \Drupal\Core\Entity\EntityInterface $entity */
    if (($entity = $this->getEntityByKey($key)) != NULL) {
      if (!method_exists($entity, 'getRevisionId')) {
        $msg = 'Entity with Key "' . $key . '" entity does not have method getRevisionId()';
        throw new \Exception($msg);
      }
      return $entity->getRevisionId();
    }
  }

  /**
   * Create an entity.
   *
   * @return object
   *   The created node.
   */
  public
  function entityCreate($entity_type, $entity) {
    $saved = $this->getDriver()->createEntity($entity_type, $entity);
    return $saved;
  }
}
