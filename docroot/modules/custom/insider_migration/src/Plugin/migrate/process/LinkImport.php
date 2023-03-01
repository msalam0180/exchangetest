<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\LinkImport.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * Import a LinkItem of a migration. Currently handles up to 5 link/title combos.
 *
 * @MigrateProcessPlugin(
 *   id = "link_import"
 * )
 */
class LinkImport extends ProcessPluginBase {
  /**
   * Parses urls from migration source
   */
  public function parseUrl($url) {
    $url = trim($url);
    if (substr($url, 0, 1) === "/") {
      $url = "internal:" . $url;
    }
    return $url;
  }
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value)) {
      // Skip this item if there's no value data.
      throw new MigrateSkipProcessException();
    }
    $all = [];
    if (isset($value[0]) and !isset($value[1])) {
      $link1 = [];
      $link1['title'] = $row->getSourceProperty("name");
      $link1['uri'] = $this->parseUrl($value[0]);
      $link1['options'] = [];
      array_push($all, $link1);
    }
    if (isset($value[0]) and isset($value[1])) {
      $link1 = [];
      $link1['title'] = $value[0];
      $link1['uri'] = $this->parseUrl($value[1]);
      $link1['options'] = [];
      array_push($all, $link1);
    }
    if (isset($value[2]) and isset($value[3])) {
      $link2 = [];
      $link2['title'] = $value[2];
      $link2['uri'] = $this->parseUrl($value[3]);
      $link2['options'] = [];
      array_push($all, $link2);
    }
    if (isset($value[4]) and isset($value[5])) {
      $link3 = [];
      $link3['title'] = $value[4];
      $link3['uri'] = $this->parseUrl($value[5]);
      $link3['options'] = [];
      array_push($all, $link3);
    }
    if (isset($value[6]) and isset($value[7])) {
      $link4 = [];
      $link4['title'] = $value[6];
      $link4['uri'] = $this->parseUrl($value[7]);
      $link4['options'] = [];
      array_push($all, $link4);
    }
    if (isset($value[8]) and isset($value[9])) {
      $link5 = [];
      $link5['title'] = $value[8];
      $link5['uri'] = $this->parseUrl($value[9]);
      $link5['options'] = [];
      array_push($all, $link5);
    }
    return $all;
  }
}
