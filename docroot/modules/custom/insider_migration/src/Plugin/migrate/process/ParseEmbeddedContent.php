<?php

namespace Drupal\insider_migration\Plugin\migrate\process;

/**
 * @file
 * Contains \Drupal\insider_migration\Plugin\migrate\process\ParseEmbeddedContent.
 */

use Drupal\migrate\MigrateExecutableInterface;
use Drupal\migrate\MigrateSkipProcessException;
use Drupal\migrate\ProcessPluginBase;
use Drupal\migrate\Row;
use Drupal\node\Entity\Node;

/**
 * Parses WCM Embedded content markup and replaces it with drupal embedded content markup
 *
 * @MigrateProcessPlugin(
 *   id = "parse_embedded_content"
 * )
 */
class ParseEmbeddedContent extends ProcessPluginBase {
  /**
   * {@inheritdoc}
   */
  public function transform($value, MigrateExecutableInterface $migrate_executable, Row $row, $destination_property) {
    if (empty($value)) {
      // Skip this item if there's no string value.
      throw new MigrateSkipProcessException();
    }
    $updatedValue = $value;
    $pattern = "/\[Asset Included\(Id:([0-9]+);Type:SEC(Article|News|Image|Link|StaticFile|PageLayoutFile)\)]/";
    if (preg_match_all($pattern, $value, $matches)) {
      $embeddedContentSourceId = $matches[1][0];
      $embeddedContentType = $matches[2][0];
      if ($embeddedContentSourceId && $embeddedContentType) {
        $embeddedContentUUID = $this->getMigratedUuid($embeddedContentSourceId, $embeddedContentType);
        if ($embeddedContentUUID) {
          $replacement = '<drupal-entity data-embed-button="node" data-entity-embed-display="view_mode:node.embed" data-entity-type="node" data-entity-uuid="' . $embeddedContentUUID . '"></drupal-entity>';
          $updatedValue = preg_replace($pattern, $replacement, $value);
        }
      }
    }
    $returnVal = [];
    $returnVal['value'] = $updatedValue;
    $returnVal['format'] = 'full_html';
    return $returnVal;
  }

  /**
   * Provides function to return UUID from a migrated WCM ID
   *
   * @param String $sourceId
   *   The WCM sourceID such as 1370547941856
   */
  public function getMigratedUuid($sourceId, $contentType) {
    $tableName = '';
    switch ($contentType) {
      case 'Image':
        $tableName = "migrate_map_secimage";
        break;
      case 'Article':
        $tableName = "migrate_map_articles";
        break;
      case 'Link':
        $tableName = "migrate_map_seclink";
        break;
      case 'StaticFile':
        $tableName = "migrate_map_secstaticfile";
        break;
      case 'News':
      case 'PageLayoutFile':
      default:
        $tableName = "migrate_map_urls";
    }
    $uuid = \Drupal::database()->query('SELECT uuid FROM node where nid = (select destid1 from ' . $tableName . ' where sourceid1 = :sourceId)', [':sourceId' => $sourceId])->fetchField();
    if (!$uuid) {
      return null;
    }
    return $uuid;
  }
}
