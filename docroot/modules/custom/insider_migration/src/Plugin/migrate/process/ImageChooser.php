<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\ImageChooser.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use Drupal\file\FileInterface;

/**
 * Choose between two images
 *
 * Chooses the large image if provided, otherwise the middle image
 *
 * @MigrateProcessPlugin(
 *   id = "image_chooser"
 * )
 */
class ImageChooser extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    // Choose large image if given, otherwise middle image
    print "In image_chooser transform function";
    if (empty($value)) {
      // Skip this item if there's no URL.
      throw new MigrateSkipProcessException();
    }
    var_dump($value);
    // Save the file, return its ID.
    // create logic to evaluate two parameters and choose the populated pone
    return null;
  }
}
