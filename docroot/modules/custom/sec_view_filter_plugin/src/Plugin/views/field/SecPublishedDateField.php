<?php

/**
 * @file
 * Definition of Drupal\sec_view_filter_plugin\Plugin\views\field\SecPublishedDateField.
 */

namespace Drupal\sec_view_filter_plugin\Plugin\views\field;

use Drupal\views\Plugin\views\field\FieldPluginBase;
use Drupal\views\ResultRow;

/**
 * Field handler to group the node by seasons.
 *
 * @ingroup views_field_handlers
 *
 * @ViewsField("sec_field_publish_date")
 */
class SecPublishedDateField extends FieldPluginBase {

  /**
   * @{inheritdoc}
   */
  public function query() {
    // Leave empty to avoid a query on this field.
  }

  /**
   * @{inheritdoc}
   */
  public function render(ResultRow $values) {
    $changed = $values->_entity->get('changed')->value;
    $override = $values->_entity->get('field_override_modified_date')->value;
    if (!is_null($override)) {
      return \Drupal::service('date.formatter')->format(strtotime($override), 'custom', 'F Y');
    } elseif (!is_null($changed)) {
      return \Drupal::service('date.formatter')->format((int) ($changed), 'custom', 'F Y');
    }
  }
}
