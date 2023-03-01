<?php

/**
 * @file
 * Definition of Drupal\sec_view_filter_plugin\Plugin\views\field\SecSeasonalField.
 */

namespace Drupal\sec_view_filter_plugin\Plugin\views\field;

use Drupal\Core\Form\FormStateInterface;
use Drupal\node\Entity\NodeType;
use Drupal\views\Plugin\views\field\FieldPluginBase;
use Drupal\views\ResultRow;

/**
 * Field handler to group the node by seasons.
 *
 * @ingroup views_field_handlers
 *
 * @ViewsField("sec_field_publish_date_seasonal")
 */
class SecSeasonalField extends FieldPluginBase {

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
    $node = $values->_entity;
    if (!empty($node->get('field_publish_date')->value)) {
      $sdate = strtotime($node->get('field_publish_date')->value);
      $year = date('Y', $sdate);
      $month = date('n', $sdate);
      $return = [];
      $season = ['Summer' => [7, 8, 9], 'Fall' => [10, 11, 12], 'Winter' => [1, 2, 3], 'Spring' => [4, 5, 6]];
      foreach ($season as $key => $val) {
        if (in_array($month, $val)) {
          $seasons =  strtoupper($key . ' ' . $year);
          $return = $seasons;
          break;
        }
      }
      return $return;
    }
  }
}
