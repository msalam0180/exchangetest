<?php

namespace Drupal\insider_linkit_alter\Plugin\Filter;

use Drupal\filter\FilterProcessResult;
use Drupal\filter\Plugin\FilterBase;
use Drupal\node\Entity\Node;


/**
 * Provides a filter to replace href Link node with field_url of that node.
 *
 * @Filter(
 *   id = "filter_insider_linkit_alter",
 *   title = @Translation("Custom Linkit URL Alter"),
 *   description = @Translation("Changing linkit URL to url field if content type is Link."),
 *   type = Drupal\filter\Plugin\FilterInterface::TYPE_MARKUP_LANGUAGE,
 * )
 */
class FilterInsiderLinkitAlter extends FilterBase {

  /**
   * {@inheritdoc}
   */
  public function process($text, $langcode) {
    $match_array = [];
    $replacement_array = [];
    /* Regex pattern to match <a href="/node/1234">Hyperlink</a> with 3 groups.
     * [0] Group 1: <a href="/node/1234">Hyperlink</a>
     * [1] Group 2: "/node/1234"
     * [2] Group 3: 1234
     */
    $link_pattern = "/<a.*href=(\"\/node\/([0-9]*)\").*<\/a>/";
    $match_text = preg_match_all($link_pattern, $text, $match_array, PREG_PATTERN_ORDER);
    // If condition to see if there are any matches within $text.
    if ($match_text > 0) {
      // Loop through array of matches.
      for ($i = 0; $i < count($match_array[1]); $i++) {
        // Get nid from matched pattern array.
        $node_id = $match_array[2][$i];
        // Get URL that needs to be replaced from matched pattern array.
        $url_replace = $match_array[1][$i];
        $node = Node::load($node_id);

        // If condition that checks to see if node type is "Link".
        if (isset($node)) {
          if ($node->getType() == 'link') {
            // If condition to check field_url is not empty.
            if (!empty($node->get('field_url')->getValue()[0]['uri'])) {
              $account = \Drupal::currentUser();
              $edit_link_access = $account->hasPermission('edit any link content');
              //modify links only if user does not have edit link permissions
              if (!$edit_link_access) {
                // Assigning field_url value to $url_value variable with quotes.
                $url_value = '"' . $node->get('field_url')->getValue()[0]['uri'] . '"';
                // Add element to array $url_replace as key, $url_value as value.
                $replacement_array += [$url_replace => $url_value];
              }
            }
          }
        }
      }
    }
    // If $replacement_array is not empty than do replacement within $text.
    if (!empty($replacement_array)) {
      $new_text = str_replace(array_keys($replacement_array), array_values($replacement_array), $text);
    } else {
      $new_text = $text;
    }
    $result = new FilterProcessResult($new_text);
    return $result;
  }
}
