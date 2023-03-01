<?php

namespace Drupal\migrate_node_media\Command;

use Drupal\Console\Core\Command\ContainerAwareCommand;
use Drupal\migrate_node_media\Service\MappingService;
use Drupal\migrate_node_media\Service\SettingsService;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;


class RunCommand extends ContainerAwareCommand {
    /**
   * Constructs a new DefaultCommand object.
   *
   * @param \Drupal\migrate_node_media\Service\SettingsService $settings_service
   */
  public function __construct() {
    parent::__construct();
  }

  /**
   * {@inheritdoc}
   */
  protected function configure() {
    $this
      ->setName('mnm:run')
      ->addArgument('map_id')
      ->setDescription($this->trans('commands.migrate_node_media.run.description'));
  }

  /**
   * {@inheritdoc}
   */
  protected function execute(InputInterface $input, OutputInterface $output) {
    $map_id = $input->getArgument('map_id');

    $output = SettingsService::runMigration($map_id);

    $this->getIo()->info($output);
    $this->getIo()
      ->info($this->trans('commands.migrate_node_media.run.messages.success'));
  }
}
