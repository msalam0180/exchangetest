<?php

namespace Drupal\migrate_node_media\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\migrate_node_media\Model\Map;
use Drupal\migrate_node_media\Service\SettingsService;

/**
 * Class MappingsForm.
 */
class MappingsForm extends FormBase {

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'mappings_form';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state) {
    // Get a list of the content types and then format them for us
    $content_type_options = $this->formatContentTypes(SettingsService::getContentTypes());

    // Get a list of the media types and then format them for us
    $media_type_options = $this->formatContentTypes(SettingsService::getMediaTypes());

    // @todo See if we still need this
    $form['#tree'] = TRUE;

    // Setup the title field for users to name their migration
    $form['title'] = [
      '#type'        => 'textfield',
      '#title'       => $this->t('Name the migration'),
      '#description' => $this->t('e.g. ArticleImage (origin content type) to MediaImage (destination media type'),
      '#weight'      => '0',
      '#required'    => TRUE,
    ];

    // Setup the content type select field with a list of the content types we
    //  previously grabbed. Kicks off an AJAX callback to see if both options
    //  are chosen.
    $form['content_type'] = [
      '#type'        => 'select',
      '#title'       => $this->t('Select the Source Content Type'),
      '#description' => $this->t('Select the source Content Type'),
      '#options'     => $content_type_options,
      '#size'        => sizeof($content_type_options),
      '#weight'      => '0',
      '#ajax'        => [
        'wrapper'  => 'maps-container',
        'callback' => '::mappingFields',
      ],
    ];

    // Setup the media type select field with a list of the media types we
    //  previously grabbed. Kicks off an AJAX callback to see if both options
    //  are chosen.
    $form['media_type'] = [
      '#type'        => 'select',
      '#title'       => $this->t('Select the Destination Media Type'),
      '#description' => $this->t('Select the destination Media Type'),
      '#options'     => $media_type_options,
      '#size'        => sizeof($media_type_options),
      '#weight'      => '0',
      '#ajax'        => [
        'wrapper'  => 'maps-container',
        'callback' => '::mappingFields',
      ],
    ];

    // Setup a container for the maps to live in (used with the AJAX)
    $form['maps'] = [
      '#type'       => 'container',
      '#attributes' => ['id' => 'maps-container'],
    ];

    // Get the content type from the form
    $content_type = $form_state->getValue(['content_type']);

    // Get the media type from the form
    $media_type = $form_state->getValue(['media_type']);

    // If both fields are filled out then load up the mappings form
    if (!empty($content_type) && !empty($media_type)) {

      // Get the list of content type fields
      $content_type_fields = $this->formatContentTypes(SettingsService::getContentTypeFields($content_type));

      // Get the list of media type fields
      $media_type_fields = $this->formatContentTypes(SettingsService::getMediaTypeFields($media_type));

      // Set a Do Not Map field
      // @todo Make this the top/default option
      $media_type_fields[0] = "- Do Not Map -";

      // Build a dropdown for the media type fields to map to the content type
      //  fields.
      foreach ($content_type_fields as $content_type_field) {

        // Check to see if any of the fields are the same and, if so, set the
        //  dropdown to that field otherwise choose Do Not Map.
        $default = in_array($content_type_field,
          $media_type_fields) ? $content_type_field : 0;

        // Building the mapping fields using the content type field as the field
        //  name and the media type fields as the options.
        $form['maps'][$content_type_field] = [
          '#type'          => 'select',
          '#title'         => $this->t("Map $content_type $content_type_field to :"),
          '#description'   => $this->t("Select the $media_type Media Type Field"),
          '#options'       => $media_type_fields,
          '#default_value' => $default,
          '#size'          => 0,
        ];
      }
    }

    // Submit, when clicked triggers submitForm method
    $form['submit'] = [
      '#type'  => 'submit',
      '#value' => $this->t('Submit'),
    ];

    // Don't cache the form
    $form_state->setCached(FALSE);

    // Let Drupal build our form now
    return $form;
  }

  /**
   * Formats the content type for Drupal forms.
   *
   * Grabs the keys from the array and sets an associative array with the new
   *  array's key and value being the content type name so the Drupal form can
   *  handle it.
   *
   * @param array $content_types
   *
   * @return array
   */
  private function formatContentTypes(array $content_types) {

    // Setup the array for the collapsed types - basically we are flattening the
    //  $content_types array.
    $collapsed_types = [];

    // Get the content type name from each item and set both key and value as
    //  the content type.
    foreach ($content_types as $key => $value) {
      $collapsed_types[$key] = $key;
    }

    // Send back the array
    return $collapsed_types;
  }

  /**
   * AJAX callback returning the updated maps form element.
   *
   * @param array $form
   * @param \Drupal\Core\Form\FormStateInterface $form_state
   *
   * @return mixed
   */
  public function mappingFields(array $form, FormStateInterface $form_state) {
    // Flag to rebuild the form
    // @todo See if it's necessary to rebuild the form now
    $form_state->setRebuild();

    // Send back the updated maps form element (from buildForm method)
    return $form['maps'];
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    parent::validateForm($form, $form_state);
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {

    // Setup the migration service
    /** @var \Drupal\migrate_node_media\Service\MappingService $mapping_service */
    $mapping_service = \Drupal::service('migrate_node_media.mapping');

    // Create map with values from the form
    $map = new Map($form_state->getValue(['title']),
      $form_state->getValue(['content_type']),
      $form_state->getValue(['media_type']));

    // Add in a blacklist for uuid and vid by default
    $map->setBlacklist(['uuid', 'vid']);

    // Take the mapping fields from the user input and add the mappings to the
    //  map object.
    // @todo We have a new setMapping method where we may be able to just send in this array
    foreach ($form_state->getValue(['maps']) as $ct_field => $md_field) {
      // Add new mapping for the current content type field
      $map->addMap($ct_field, $md_field);
    }

    // Save the map to the database
    try {
      $mapping_service->create($map);
    } catch (\Exception $e) {
      echo 'Error adding map to the database: ', $e->getMessage(), "\n";
    }
  }

}
