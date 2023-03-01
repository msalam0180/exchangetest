<?php

namespace Drupal\migrate_node_media\Command;

use Drupal\Console\Core\Command\ContainerAwareCommand;
use Drupal\migrate_node_media\Service\MappingService;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;


class ListCommand extends ContainerAwareCommand {

  /**
   * The $entityTypeManager definition.
   *
   * @var MappingService $mapping_service
   */
  protected $mapping_service;

  /**
   * Constructs a new DefaultCommand object.
   *
   * @param \Drupal\migrate_node_media\Service\MappingService $mapping_service
   */
  public function __construct(MappingService $mapping_service) {
    $this->mapping_service = $mapping_service;
    parent::__construct();
  }

  /**
   * {@inheritdoc}
   */
  protected function configure() {
    $this
      ->setName('mnm:list')
      ->setDescription($this->trans('commands.migrate_node_media.list.description'));
  }

  /**
   * {@inheritdoc}
   */
  protected function execute(InputInterface $input, OutputInterface $output) {
    /** @var MappingService $mapping_service */
    $mapping_service = $this->get('migrate_node_media.mapping');
    $content_types = $mapping_service->getAll();
    $this->getIo()->info(print_r($content_types, TRUE));
    $this->getIo()
      ->info($this->trans('commands.migrate_node_media.list.messages.success'));
  }
}
