<?php

/**
 * @file
 * Contains Drupal\sec_view_filter_plugin\Controller\SecFilterController.
 */

namespace Drupal\sec_view_filter_plugin\Controller;

class SecFilterController {

  private $_bundleType;
  private $_form;

  function __construct($bundleType, &$form) {
    $this->_bundleType = $bundleType;
    $this->_form = &$form;
  }

  public function getList($bundle, $field) {

    $queryObject = $this->_getQuery($this->_bundleType);
    $options = ['All' => '- Any -'];

    if (in_array($bundle, $this->_bundleType)) {
      $key = array_search($bundle, $this->_bundleType);
      foreach ($queryObject[$key] as $node) {
        $options[$node->title] = $node->title;
      }
    }

    //Generate Dynamic drop down;
    $this->_form[$field]['#type'] =  "select";
    $this->_form[$field]['#validated'] = TRUE;
    $this->_form[$field]['#options'] = $options;
    //Will resolve issue with 'content-type' checkbox validation;
    $this->_form['type']['#validated'] = TRUE;

    //Shift elements back at its previous position;
    $this->_arrayShift($this->_form, 26, 5); //Article Type
    $this->_arrayShift($this->_form, 27, 4); //News Type
    $this->_arrayShift($this->_form, 28, 7); //Person

  }

  /**
   * [getQueryforType description]
   * @param  array  $bundleTypes [description]
   * @return [type]              [description]
   */
  private function _getQuery($bundleTypes) {
    $queryObject = [];
    foreach ($bundleTypes as $bundle) {

      $queryObject[] = \Drupal::database()->query('SELECT title FROM {node_field_data} WHERE status = :status AND type = :type ORDER BY title', array(':status' => 1, ':type' => $bundle))->fetchAll();
    }
    return $queryObject;
  }

  /**
   * [_arrayShift description]
   * @param  [type] $array       [description]
   * @param  [type] $currentIndex [description]
   * @param  [type] $nextIndex    [description]
   * @return [type]               [description]
   */
  private function _arrayShift(&$array, $currentIndex, $nextIndex) {
    $p1 = array_splice($array, $currentIndex, 1);
    $p2 = array_splice($array, 0, $nextIndex);
    $array = array_merge($p2, $p1, $array);
    return $array;
  }
}
