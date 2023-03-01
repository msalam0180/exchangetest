<?php

namespace Drupal\comment\Plugin\views\field;

use Drupal\comment\Plugin\Field\FieldType\CommentItemInterface;
use Drupal\views\Plugin\views\field\FieldPluginBase;
use Drupal\views\ResultRow;

/**
 * The plugin display which displays the status of the comments for entity.
 *
 * @ViewsField("comment_status")
 */
class CommentStatus extends FieldPluginBase {

  /**
   * {@inheritdoc}
   */
  public function render(ResultRow $values) {
    $value = $this->getValue($values);

    switch ($value) {
      case CommentItemInterface::OPEN:
        $value = $this->t('Open');
        break;

      case CommentItemInterface::CLOSED:
        $value = $this->t('Closed');
        break;

      case CommentItemInterface::HIDDEN:
        $value = $this->t('Hidden');
        break;
    }

    return $this->sanitizeValue($value);
  }

}
