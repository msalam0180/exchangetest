<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

use Drupal\migrate\MigrateException;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use DateTime;

/**
 * Add 3 years to publish date and this value to Expire field.
 *
 * @MigrateProcessPlugin(
 *   id = "expire_retain_date"
 * )
 */
class ExpireDateImport extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value)) {
      // Skip this item if there's no value.
      throw new MigrateSkipProcessException();
    }
    $date = new DateTime($value);
    $date->modify('+3 years');
    return $date->format('Y-m-d'); // 2016-01-13
  }
}
