<?php

namespace Drupal\comment\Plugin\views\filter;

use Drupal\comment\Plugin\Field\FieldType\CommentItemInterface;
use Drupal\views\Plugin\views\filter\InOperator;

/**
 * Filter based on comment node status.
 *
 * @ingroup views_filter_handlers
 *
 * @ViewsFilter("node_comment")
 */
class NodeComment extends InOperator {

  /**
   * {@inheritdoc}
   */
  public function getValueOptions() {
    $this->valueOptions = [
      CommentItemInterface::HIDDEN => (string) $this->t('Hidden'),
      CommentItemInterface::CLOSED => (string) $this->t('Closed'),
      CommentItemInterface::OPEN => (string) $this->t('Open'),
    ];
    return $this->valueOptions;
  }

}
