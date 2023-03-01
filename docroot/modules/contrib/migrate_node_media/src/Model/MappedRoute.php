<?php

namespace Drupal\migrate_node_media\Model;

/**
 * Class MappedRoute.
 *  Stores the data related to a old content type routes and new media routes.
 */
class MappedRoute {

  /** @var integer */
  private $id;

  /** @var integer */
  private $map_id;

  /** @var integer $nid */
  private $nid;

  /** @var integer $mid */
  private $mid;

  /** @var string */
  private $content_route;

  /** @var string */
  private $media_route;

  /**
   * MappedRoute constructor.
   *
   * @param int $nid
   * @param int $mid
   * @param int $map_id
   */
  public function __construct(int $nid, int $mid, int $map_id) {
    $this->nid = $nid;
    $this->mid = $mid;
    $this->setContentRoute("/node/" . $nid);
    $this->setMediaRoute("/media/" . $mid);
    $this->map_id = $map_id;
  }

  /**
   * @return int
   */
  public function getId(): int {
    return $this->id;
  }

  /**
   * @param int $id
   */
  public function setId(int $id): void {
    $this->id = $id;
  }

  /**
   * @return string
   */
  public function getContentRoute(): string {
    return $this->content_route;
  }

  /**
   * @param string $content_route
   */
  public function setContentRoute(string $content_route): void {
    $this->content_route = $content_route;
  }

  /**
   * @return string
   */
  public function getMediaRoute(): string {
    return $this->media_route;
  }

  /**
   * @param string $media_route
   */
  public function setMediaRoute(string $media_route): void {
    $this->media_route = $media_route;
  }

  /**
   * @return int
   */
  public function getMapId(): int {
    return $this->map_id;
  }

  /**
   * @param int $map_id
   */
  public function setMapId(int $map_id): void {
    $this->map_id = $map_id;
  }

  /**
   * @return int
   */
  public function getNid(): int {
    return $this->nid;
  }

  /**
   * @param int $nid
   */
  public function setNid(int $nid): void {
    $this->nid = $nid;
  }

  /**
   * @return int
   */
  public function getMid(): int {
    return $this->mid;
  }

  /**
   * @param int $mid
   */
  public function setMid(int $mid): void {
    $this->mid = $mid;
  }

}