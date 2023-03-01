<?php

/**
 * Implements hook_views_data_alter().
 */

function sec_view_filter_plugin_views_data_alter(array &$data) {
  $data['node_field_data']['year'] = array(
    'title' => t('Custom Year'),
    'filter' => array(
      'title' => t('Custom Year filter (Published date)'),
      'help' => t('Filters nodes on given Year (*Requires relationship with field_publish_date)'),
      'field' => 'field_date_value',
      'id' => 'sec_year_filter'
    ),
  );

  $data['node_field_data']['month'] = array(
    'title' => t('Custom Month'),
    'filter' => array(
      'title' => t('Custom Month filter (Published date)'),
      'help' => t('Filters nodes on given Month (*Requires relationship with field_publish_date)'),
      'field' => 'field_date_value',
      'id' => 'sec_month_filter'
    ),
  );

  $data['node_field_data']['sec_seasonal_field'] = array(
    'title' => t('Grouped by seasons'),
    'group' => t('Content'),
    'field' => array(
      'title' => t('Seasonal grouping'),
      'help' => t('Group content by seasons.'),
      'id' => 'sec_field_publish_date_seasonal',
    ),
  );

  $data['node_field_data']['sec_publish_date_field'] = array(
    'title' => t('Grouped by Published date'),
    'group' => t('Content'),
    'field' => array(
      'title' => t('Published date grouping'),
      'help' => t('Group content by published date or event start date.'),
      'id' => 'sec_field_publish_date',
    ),
  );
}
