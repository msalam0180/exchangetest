<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\HtmlImport.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use Drupal\node\Entity\Node;

/**
 * Imports HTML Content and sets format to full_html
 *
 * @MigrateProcessPlugin(
 *   id = "html_import"
 * )
 */
class HtmlImport extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value)) {
      // Skip this item if there's no string value.
      throw new MigrateSkipProcessException();
    }
    $returnVal = [];
    $returnVal['value'] = $value;
    $returnVal['format'] = 'full_html';
    return $returnVal;
  }
}
