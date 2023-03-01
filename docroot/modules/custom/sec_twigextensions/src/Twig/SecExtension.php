<?php

namespace Drupal\sec_twigextensions\Twig;

use Drupal\Core\Datetime\DrupalDateTime;
use DateTimeZone;
use DateInterval;

/**
 * Provides the Kint debugging function within Twig templates.
 */
class SecExtension extends \Twig_Extension {
  /**
   * {@inheritdoc}
   */
  public function getName() {
    return 'sec_extension';
  }

  /**
   * {@inheritdoc}
   */
  public function getFunctions() {
    return array(
      new \Twig_SimpleFunction('render_menu', array($this, 'render_menu')),
    );
  }

  /**
   * Generates a list of all Twig filters that this extension defines.
   */
  public function getFilters() {
    return [
      new \Twig_SimpleFilter('apdate', array($this, 'apDate')),
      new \Twig_SimpleFilter('apTime', array($this, 'apTime')),
      new \Twig_SimpleFilter('apTimeNoTimeZone', array($this, 'apTimeNoTimeZone')),
      new \Twig_SimpleFilter('timezoneDate', array($this, 'timezoneDate')),
      new \Twig_SimpleFilter('apDateMonthYear', array($this, 'apDateMonthYear')),
      new \Twig_SimpleFilter('regexReplace', array($this, 'regexReplace')),
    ];
  }

  /**
   * Formats a date in AP format.
   */
  public function apDate($timestamp) {
    if (!empty($timestamp)) {
      $date = $this->getTimeZoneAdjustedDateTime($timestamp, new DateTimeZone('America/New_York'));

      $month = $this->getAPMonth($date);
      $day = $date->format("j");
      $year = $date->format("Y");

      return $month . " " . $day . ", " . $year;
    }
  }

  /**
   * Formats a time in AP format.
   */
  public function apTime($timestamp) {
    if (!empty($timestamp)) {
      $date = $this->getTimeZoneAdjustedDateTime($timestamp, new DateTimeZone('America/New_York'));

      return $date->format('g:i a T');
    }
  }

  /**
   * Formats a time in AP format with no TimeZone.
   */
  public function apTimeNoTimeZone($timestamp) {
    if (!empty($timestamp)) {
      $date = $this->getTimeZoneAdjustedDateTime($timestamp, new DateTimeZone('America/New_York'));

      return $date->format('g:i a');
    }
  }

  /**
   * Formats a date in AP format.
   */
  public function apDateMonthYear($timestamp) {
    if (!empty($timestamp)) {
      $date = $this->getTimeZoneAdjustedDateTime($timestamp, new DateTimeZone('America/New_York'));
      $month = $this->getAPMonth($date);
      $year = $date->format("Y");

      return $month . " " . $year;
    }
  }

  /**
   * Formats a Date Time in AP format.
   */
  public function timezoneDate($timestamp) {
    if (!empty($timestamp)) {
      return $this->getTimeZoneAdjustedDateTime($timestamp, new DateTimeZone('America/New_York'));
    }
  }

  /***
   * Correctly offsets time into given timezone
   */
  public static function getTimeZoneAdjustedDateTime($timestamp, $timezone) {
    if (!empty($timestamp)) {

      if (is_numeric($timestamp)) $timestamp = date('Y-m-d H:i:s', $timestamp);
      if (is_array($timestamp) && isset($timestamp["#attributes"])) $timestamp = $timestamp["#attributes"]["datetime"];

      $utcTimezone = new DateTimeZone('UTC');
      $serverDateTime = new \DateTime($timestamp, $utcTimezone);
      $offset = $timezone->getOffset($serverDateTime);
      $myInterval = DateInterval::createFromDateString((string)$offset . 'seconds');
      $serverDateTime->add($myInterval);
      $result = $serverDateTime->format('Y-m-d H:i:s');

      return new \DateTime($result, $timezone);
    }
  }

  /**
   * Returns a month based on AP Formatting.
   * When a month is used with a specific date, you may abbreviate "Jan." "Feb." "Aug." "Sept." "Oct." "Nov." and "Dec."
   * All remaining months may not be abbreviated.
   * @param Timestamp $timestamp
   * @return string
   */
  private function getAPMonth($date) {

    $month = $date->format("m");
    switch ($month) {
      case "01":
      case "02":
      case "08":
      case "10":
      case "11":
      case "12":
        return $date->format("M") . ".";
        break;
      case "09":
        return "Sept.";
        break;
      default:
        return $date->format("F");
        break;
    }
  }

  /**
   * Expose preg_replace in twig
   * @param String $pattern - Regex pattern to search for
   * @param String $replacement - String to replace
   * @param String $subject - String to search and replace
   * @param int $limit
   * @return string
   */
  public function regexReplace($subject, $pattern, $replacement = '', $limit = -1) {

    if (!isset($subject)) {
      return null;
    } else {
      return preg_replace($pattern, $replacement, $subject, $limit);
    }
  }

  /**
   * Provides function to programmatically rendering a menu
   *
   * @param String $menu_name
   *   The machine configuration id of the menu to render
   */
  public function render_menu($menu_name) {
    $menu_tree = \Drupal::menuTree();

    // Build the typical default set of menu tree parameters.
    $parameters = $menu_tree->getCurrentRouteMenuTreeParameters($menu_name);

    // Load the tree based on this set of parameters.
    $tree = $menu_tree->load($menu_name, $parameters);

    // Transform the tree
    $manipulators = array(
      // Only show links that are accessible for the current user.
      array('callable' => 'menu.default_tree_manipulators:checkAccess'),
      // Use the default sorting of menu links.
      array('callable' => 'menu.default_tree_manipulators:generateIndexAndSort'),
    );
    $tree = $menu_tree->transform($tree, $manipulators);

    // Finally, build a renderable array from the transformed tree.
    $menu = $menu_tree->build($tree);

    return  array('#markup' => \Drupal::service('renderer')->render($menu));
  }
}
