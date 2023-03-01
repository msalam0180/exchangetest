<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\FileImport.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use Drupal\file\FileInterface;
use Drupal\Core\File\FileSystemInterface;

/**
 * Import a file as a side-effect of a migration.
 *
 * Fetches the file, and yields a file ID.
 *
 * @MigrateProcessPlugin(
 *   id = "file_import"
 * )
 */
class FileImport extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value)) {
      // Skip this item if there's no URL.
      throw new MigrateSkipProcessException();
    }
    // Save the file, return its ID.
    $file = system_retrieve_file($value, 'public://', true, FileSystemInterface::EXISTS_REPLACE);
    $altText = "";
    if ($file instanceof FileInterface) {
      if ($row->hasSourceProperty("Alternative_text")) {
        $altText = $row->getSourceProperty("Alternative_text");
      } elseif ($row->hasSourceProperty("subtype")) {
        if ($row->getSourceProperty("subtype") == "Person") {
          $altText = $row->getSourceProperty("name");
        }
      }
      return [
        'target_id' => $file->id(),
        'alt' => $altText,
      ];
    } else {
      return null;
    }
  }
}
