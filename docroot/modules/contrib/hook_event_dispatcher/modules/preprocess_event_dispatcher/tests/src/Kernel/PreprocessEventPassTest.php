<?php

namespace Drupal\Tests\preprocess_event_dispatcher\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\preprocess_event_dispatcher\Event\EckEntityPreprocessEvent;
use Drupal\preprocess_event_dispatcher\Event\HtmlPreprocessEvent;
use Drupal\Tests\preprocess_event_dispatcher\Unit\Helpers\FakePreprocessEvent;
use Drupal\Tests\preprocess_event_dispatcher\Unit\Helpers\FakePreprocessEventFactory;

/**
 * Class PreprocessEventPassTest.
 *
 * @group hook_event_dispatcher
 * @group preprocess_event_dispatcher
 */
class PreprocessEventPassTest extends KernelTestBase {

  /**
   * {@inheritdoc}
   */
  protected static $modules = [
    'hook_event_dispatcher',
    'preprocess_event_dispatcher',
    'preprocess_event_dispatcher_test',
  ];

  /**
   * Test if we can overwrite a default factory.
   *
   * Using the preprocess_event_dispatcher_factory tag.
   *
   * @throws \Exception
   */
  public function testOverwritingDefaultFactory(): void {
    /** @var \Drupal\preprocess_event_dispatcher\Service\PreprocessEventFactoryMapper $mapper */
    $mapper = $this->container->get('preprocess_event.factory_mapper');
    $variables = [];

    $eckMappedFactory = $mapper->getFactory(EckEntityPreprocessEvent::getHook());
    $this->assertInstanceOf(FakePreprocessEventFactory::class, $eckMappedFactory);
    $this->assertSame(EckEntityPreprocessEvent::getHook(), $eckMappedFactory->getEventHook());
    $this->assertInstanceOf(FakePreprocessEvent::class, $eckMappedFactory->createEvent($variables));

    $htmlMappedFactory = $mapper->getFactory(HtmlPreprocessEvent::getHook());
    $this->assertInstanceOf(FakePreprocessEventFactory::class, $htmlMappedFactory);
    $this->assertSame(HtmlPreprocessEvent::getHook(), $htmlMappedFactory->getEventHook());
    $this->assertInstanceOf(FakePreprocessEvent::class, $htmlMappedFactory->createEvent($variables));
  }

}
