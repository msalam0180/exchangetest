<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

use Drupal\migrate\MigrateException;
use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\MigrateSkipRowException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;

/**
 * If the source evaluates to a configured value, skip processing or whole row.
 *
 * @MigrateProcessPlugin(
 *   id = "skip_on_contains"
 * )
 */
class SkipOnContains extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function row($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($this->configuration['contains']) && !array_key_exists('contains', $this->configuration)) {
      throw new MigrateException('Skip on value plugin is missing value configuration.');
    }
    if (is_array($this->configuration['contains'])) {
      foreach ($this->configuration['contains'] as $skipValue) {
        if (strpos($value, $skipValue) !== false) {
          throw new MigrateSkipRowException();
        }
      }
    } elseif (strpos($value, $this->configuration['contains']) !== false) {
      throw new MigrateSkipRowException();
    }
    return $value;
  }

  /**
   * {@inheritdoc}
   */
  public function process($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($this->configuration['contains']) && !array_key_exists('contains', $this->configuration)) {
      throw new MigrateException('Skip on contains plugin is missing value configuration.');
    }
    if (is_array($this->configuration['contains'])) {
      foreach ($this->configuration['contains'] as $skipValue) {
        if (strpos($value, $skipValue) !== false) {
          throw new MigrateSkipProcessException();
        }
      }
    } elseif (strpos($value, $this->configuration['contains']) !== false) {
      throw new MigrateSkipProcessException();
    }
    return $value;
  }
}
