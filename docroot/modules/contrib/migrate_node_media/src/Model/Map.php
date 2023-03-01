<?php

namespace Drupal\migrate_node_media\Model;

/**
 * Class Map.
 *  Stores the data related to a mapping.
 */
class Map {

  /** @var integer */
  private $id;

  /** @var string */
  private $name;

  /** @var string */
  private $content_type;

  /** @var string */
  private $media_type;

  /** @var array */
  private $mappings;

  /** @var array */
  private $blacklist;

  /** @var integer */
  private $run_count;

  /**
   * Map constructor.
   *
   * @param string $name
   * @param string $content_type
   * @param string $media_type
   */
  public function __construct(
    string $name,
    string $content_type,
    string $media_type
  ) {
    $this->name = $name;
    $this->content_type = $content_type;
    $this->media_type = $media_type;
    $this->mappings = [];
    $this->blacklist = ['uuid', 'vid'];
    $this->run_count = 0;
  }

  /**
   * Retrieves the number of times a migration has been run with this map.
   *
   * @return int
   */
  public function getRunCount(): int {
    return $this->run_count;
  }

  /**
   * Increments the run count upon run.
   *
   * @param int $run_count
   */
  public function setRunCount(int $run_count): void {
    $this->run_count = $run_count;
  }

  /**
   * Adds a mapping pair to the map in the $key => $value format.
   *
   * @param string $content_field
   * @param string $media_field
   */
  public function addMap(string $content_field, string $media_field) {
    $this->mappings[$content_field] = $media_field;
  }

  /**
   * Retrieves all of the mappings for this map.
   *
   * @return array
   */
  public function getMappings(): array {
    return $this->mappings;
  }

  /**
   * Bulk create mappings in $key => $value pairs.
   *
   * @param array $mappings
   */
  public function setMappings(array $mappings): void {
    $this->mappings = $mappings;
  }

  /**
   * Retrieves the name of the map.
   *
   * @return string
   */
  public function getName(): string {
    return $this->name;
  }

  /**
   * Retrieves the content type associated with the map.
   *
   * @return string
   */
  public function getContentType(): string {
    return $this->content_type;
  }

  /**
   * Retrieves the media type associated with the map.
   *
   * @return string
   */
  public function getMediaType(): string {
    return $this->media_type;
  }

  /**
   * Retrieves the blacklisted fields associated with the map.
   *
   * @return array
   */
  public function getBlacklist(): array {
    return $this->blacklist;
  }

  /**
   * Bulk setting of blacklisted fields.
   *
   * @param array $blacklist
   */
  public function setBlacklist(array $blacklist): void {
    $this->blacklist = $blacklist;
  }

  /**
   * Retrieves the database ID of the map.
   *
   * @return integer
   */
  public function getId(): int {
    return $this->id;
  }

  /**
   * Sets the ID of the map when pulling from the database.
   *
   * @param integer $id
   */
  public function setId(int $id): void {
    $this->id = $id;
  }
}