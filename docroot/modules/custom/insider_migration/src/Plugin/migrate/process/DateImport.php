<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\DateImport.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use DateTime;
use Drupal\Core\Datetime\DrupalDateTime;

/**
 * Import a date string (eg unix timestamp in milliseconds) to a Date value.
 *
 * @MigrateProcessPlugin(
 *   id = "date_import",
 *   return_timestamp = TRUE,
 *   default_value = null
 * )
 */
class DateImport extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    $hasDefaultValue = !empty($this->configuration['default_value']) ?: false;
    if (empty($value) && $hasDefaultValue) {
      $defaultValue = $row->getSourceProperty($this->configuration['default_value']);
      $value = $defaultValue;
    }
    if (empty($value)) {
      // Skip this item if there's no value.
      throw new MigrateSkipProcessException();
    }
    $IsReturnTimestamp = !empty($this->configuration['return_timestamp']) ?: false;
    $timestamp = null;
    if (is_numeric($value)) {
      //eg a unix timestamp in milliseconds
      $timestamp = round($value / 1000);
    } else {
      //eg a date string such as "03/11/2011"
      $timestamp = strtotime($value);
    }
    if ($IsReturnTimestamp) {
      return $timestamp;
    } else {
      $dt = new DateTime();
      $dt->setTimestamp($timestamp);
      $dt->setTimezone(new \DateTimeZone('UTC'));
      return date_format($dt, 'Y-m-d\TH:i:s');
    }
  }
}
