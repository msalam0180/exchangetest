<?php

/**
 * @file
 * Contains \Drupal\config\ConfigMailSubscriber.
 */

namespace Drupal\config_log\EventSubscriber;

use Drupal\Component\Utility\DiffArray;
use Drupal\Core\Config\Config;
use Drupal\Core\Config\ConfigCrudEvent;
use Drupal\Core\Config\ConfigEvents;
use Drupal\Core\Config\ConfigFactory;
use Drupal\Core\Config\ConfigFactoryInterface;
use Drupal\Core\Mail\MailManagerInterface;
use Drupal\Core\Language\LanguageManagerInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Drupal\Core\StringTranslation\StringTranslationTrait;

/**
 * Config subscriber.
 */
class ConfigLogMailSubscriber extends ConfigLogSubscriberBase {

  use StringTranslationTrait;

  /**
   * The logger.
   *
   * @var \Psr\Log\LoggerInterface
   */
  protected $logger;

  /**
   * The mail manager.
   *
   * @var \Drupal\Core\Mail\MailManagerInterface
   */
  protected $mailManager;

  /**
   * The language manager.
   *
   * @var \Drupal\Core\Language\LanguageManagerInterface
   */
  protected $languageManager;

  /**
   * The type of the subscriber.
   *
   * @var string
   */
  public static $type = 'mail';

  /**
   * {@inheritdoc}
   *
   * @param \Drupal\Core\Mail\MailManagerInterface $mail_manager
   *   The mail manager.
   * @param \Drupal\Core\Config\ConfigFactoryInterface $config_factory
   *   The config factory services.
   * @param \Drupal\Core\Language\LanguageManagerInterface $language_manager
   *   The language manager.
   */
  public function __construct(MailManagerInterface $mail_manager, ConfigFactoryInterface $config_factory, LanguageManagerInterface $language_manager) {
    $this->mailManager = $mail_manager;
    $this->languageManager = $language_manager;
    parent::__construct($config_factory);
  }

  /**
   * {@inheritdoc}
   */
  static function getSubscribedEvents() {
    $events[ConfigEvents::SAVE][] = ['onConfigSave', 20];
    $events[ConfigEvents::DELETE][] = ['onConfigSave', 20];
    return $events;
  }

  /**
   * Save config.
   *
   * @param \Drupal\Core\Config\ConfigCrudEvent $event
   *   The config CRUD event.
   */
  public function onConfigSave(ConfigCrudEvent $event) {
    if (!$this->isEnabled()) {
      return;
    }
    $log_email_address = $this->configFactory->get('config_log.settings')->get('log_email_address');
    if (empty($log_email_address)) {
      return;
    }
    $config = $event->getConfig();
    if ($this->isIgnored($config->getName())) {
      return;
    }
    $diff = DiffArray::diffAssocRecursive($config->get(), $config->getOriginal());

    $changes = $this->gatherChanges($config, $diff);
    if (!empty($changes)) {
      $langcode = $this->languageManager->getDefaultLanguage()->getId();
      $params['context']['subject'] = $this->t('[@site] Configuration change', ['@site' => $this->configFactory->get('system.site')->get('name')]);
      $params['context']['message'] = $this->t('User ID: @id', ['@id' => \Drupal::currentUser()->id()])
        . '<br />' . $changes;
      $to = $log_email_address;
      $this->mailManager->mail('system', 'mail', $to, $langcode, $params);
    }
  }

  /**
   * The gather changes.
   *
   * @param \Drupal\Core\Config\Config $config
   *   The config.
   * @param array $diff
   *   The config diff.
   * @param string $subkey
   *   The sub key.
   *
   * @return string
   *   The return config changes.
   */
  protected function gatherChanges(Config $config, array $diff, string $subkey = NULL) {
    $changes = '';
    foreach ($diff as $key => $value) {
      $full_key = $key;
      if ($subkey) {
        $full_key = $this->joinKey($subkey, $key);
      }

      if (is_array($value)) {
        $changes .= $this->gatherChanges($config, $diff[$key], $full_key);
      }
      else {
        $changes .= $this->t("Configuration changed: %key changed from %original to %value", [
          '%key' => $this->joinKey($config->getName(), $full_key),
          '%original' => $this->format($config->getOriginal($full_key)),
          '%value' => $this->format($value),
        ]) . '<br />';
      }
    }
    return $changes;
  }

  /**
   * The format value.
   *
   * @param mixed $value
   *   The value.
   *
   * @return mixed
   *   Return format.
   */
  private function format($value) {
    if ($value === NULL) {
      return "NULL";
    }

    if ($value === "") {
      return '<empty string>';
    }

    if (is_bool($value)) {
      return ($value ? 'TRUE' : 'FALSE');
    }

    return $value;
  }

  /**
   * The join config keys.
   *
   * @param string $subkey
   *   The sub key.
   * @param string $key
   *   The key.
   *
   * @return string
   *   Merged key.
   */
  private function joinKey($subkey, $key) {
    return $subkey . '.' . $key;
  }

}
