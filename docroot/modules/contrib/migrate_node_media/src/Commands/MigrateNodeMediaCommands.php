<?php

namespace Drupal\migrate_node_media\Commands;

use Consolidation\OutputFormatters\StructuredData\RowsOfFields;
use Drupal\migrate_node_media\Service\SettingsService;
use Drush\Commands\DrushCommands;

/**
 * A Drush commandfile.
 *
 * In addition to this file, you need a drush.services.yml
 * in root of your module, and a composer.json file that provides the name
 * of the services file to use.
 *
 * See these files for an example of injecting Drupal services:
 *   - http://cgit.drupalcode.org/devel/tree/src/Commands/DevelCommands.php
 *   - http://cgit.drupalcode.org/devel/tree/drush.services.yml
 */
class MigrateNodeMediaCommands extends DrushCommands {

  /**
   * Runs a migration.
   *
   * @param $map_id
   * @param array $options
   *
   * @command migrate_node_media:run
   * @aliases mnm:run
   * @options arr An option that takes multiple values.
   * @options map_id The ID of the Map to use for a migration.
   * @usage migrate_node_media:run 1
   *   Runs the migration.
   */
  public function run($map_id, $options = ['msg' => FALSE]) {
    $this->output()->writeln("Running migration: $map_id");

    $output = SettingsService::runMigration($map_id);

    $this->output()->writeln($output);
  }

  /**
   * Command description here.
   *
   * @param $arg1
   *   Argument description.
   * @param array $options
   *   An associative array of options whose values come from cli, aliases, config, etc.
   * @option option-name
   *   Description
   * @usage migrate_node_media-commandName foo
   *   Usage description
   *
   * @command migrate_node_media:commandName
   * @aliases foo
   */
  public function commandName($arg1, $options = ['option-name' => 'default']) {
    $this->logger()->success(dt('Achievement unlocked.'));
  }

  /**
   * An example of the table output format.
   *
   * @param array $options An associative array of options whose values come from cli, aliases, config, etc.
   *
   * @field-labels
   *   group: Group
   *   token: Token
   *   name: Name
   * @default-fields group,token,name
   *
   * @command migrate_node_media:token
   * @aliases token
   *
   * @filter-default-field name
   * @return \Consolidation\OutputFormatters\StructuredData\RowsOfFields
   */
  public function token($options = ['format' => 'table']) {
    $all = \Drupal::token()->getInfo();
    foreach ($all['tokens'] as $group => $tokens) {
      foreach ($tokens as $key => $token) {
        $rows[] = [
          'group' => $group,
          'token' => $key,
          'name' => $token['name'],
        ];
      }
    }
    return new RowsOfFields($rows);
  }
}
