<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\ArrayFilter.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * Array Filter cleans empty or null elements from arrays
 *
 * @see \Drupal\migrate\Plugin\MigrateProcessInterface
 *
 * @MigrateProcessPlugin(
 *   id = "array_filter"
 * )
 */
class ArrayFilter extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (is_array($value)) {
      return array_filter($value);
    }
    return [];
  }
}
