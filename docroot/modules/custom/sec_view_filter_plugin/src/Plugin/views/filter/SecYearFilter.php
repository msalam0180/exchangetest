<?php

/**
 * @file
 * Definition of Drupal\sec_view_filter_plugin\Plugin\views\filter\SecYearFilter.
 */

namespace Drupal\sec_view_filter_plugin\Plugin\views\filter;

use Drupal\views\Plugin\views\display\DisplayPluginBase;
use Drupal\views\Plugin\views\filter\InOperator;
use Drupal\views\Views;
use Drupal\views\ViewExecutable;

/**
 * Filters by given list of Year options.
 *
 * @ingroup views_filter_handlers
 *
 * @ViewsFilter("sec_year_filter")
 */
class SecYearFilter extends InOperator {

  /**
   * {@inheritdoc}
   */
  public function init(ViewExecutable $view, DisplayPluginBase $display, array &$options = NULL) {
    parent::init($view, $display, $options);
    $this->valueTitle = t('Allowed year values');
    $this->definition['options callback'] = array($this, 'generateOptions');
  }

  /**
   * Override the query so that no filtering takes place if the user doesn't
   * select any options.
   */
  public function query() {
    $configuration = [
      'table' => 'node__field_publish_date',
      'field' => 'entity_id',
      'left_table' => 'node_field_data',
      'left_field' => 'nid',
      'operator' => '='
    ];

    if (isset($this->view->sort['field_display_title_value'])) {
      $join = Views::pluginManager('join')->createInstance('standard', $configuration);
      $filedQuery = $this->view->sort['field_display_title_value']->query;
      $filedQuery->addRelationship('node__field_publish_date', $join, 'node_field_data');
    }

    if (!empty($this->value)) {
      $this->query->addWhereExpression(0, 'YEAR(node__field_publish_date.field_publish_date_value) = :year',
        array(':year' => $this->value[0]));
    }
  }

  /**
   * Skip validation if no options have been chosen so we can use it as a
   * non-filter.
   */
  public function validate() {
    if (!empty($this->value)) {
      parent::validate();
    }
  }

  /**
   * Helper function that generates the options.
   * @return array
   */
  public function generateOptions() {
    $options = [];
    return $options;
  }
}
