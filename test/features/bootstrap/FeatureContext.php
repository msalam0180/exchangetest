<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Context\DrupalContext;
use Behat\MinkExtension\Context\RawMinkContext;
use Drupal\DrupalExtension\Hook\Scope\EntityScope;
use Behat\Mink\Exception\UnsupportedDriverActionException;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Testwork\Hook\Scope\BeforeSuiteScope;
use Drupal\Core\File\FileSystem;
use Drupal\File\Entity\File;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends RawDrupalContext implements Context, SnippetAcceptingContext
{

  /** @var \Behat\MinkExtension\Context\MinkContext */
    private $minkContext;

  /**
   * @BeforeScenario
   */
  public function gatherContexts(BeforeScenarioScope $scope)
  {
    $environment = $scope->getEnvironment();
    $this->minkContext = $environment->getContext('Drupal\DrupalExtension\Context\MinkContext');
  }

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
  }

  /**
   * remove all content type nodes which have list page testing
   * before running suite to allow list page tests to run
   * @BeforeSuite
   */
  public static function removeData(BeforeSuiteScope $scope)
  {
      // Allow tester to bypass content deletion. This comes in handy when testing specific features or scenarios.
      // Tester can supply 'nodelete' after value provided for the name, tags, or role option.
      // Example: bin/behat --tags eventsandwebcasts,nodelete
      $deleteContent = true;
      try {
        $filterString = $GLOBALS['argv'][2];
        if (strpos($filterString, 'nodelete') !== false) {
          $deleteContent = false;
        }
      }
      catch (Exception $e) {
        $deleteContent = true;
      }

      $database = \Drupal::database();
      $storage_handler = \Drupal::entityTypeManager()->getStorage('node');

      $types = array('announcement','event','featured','form','library_item','sec_article','secr','video','file','operating_procedure','image','node_log','gallery','sec_alert');
      if ($deleteContent) {
        //delete nodes
        do {

            $nids_query = $database->select('node', 'n')
                              ->fields('n', array('nid'))
                              ->condition('n.type', $types, 'IN')
                              ->range(0, 200)
                              ->execute();
            $nids = $nids_query->fetchCol();
            $entities = $storage_handler->loadMultiple($nids);
            $storage_handler->delete($entities);
        } while (!empty($nids));

        // Delete paragraph entities during behat runs
        $storage_handler = \Drupal::entityTypeManager()->getStorage('paragraph');
        $entities = $storage_handler->loadMultiple();
        $storage_handler->delete($entities);

        // Delete poll entities during behat runs
        $entities = \Drupal::entityTypeManager()->getStorage('poll')->loadMultiple();
        foreach($entities as $item){
          $item->delete();
        }

        // Delete comment entities during behat runs
        $entities = \Drupal::entityTypeManager()->getStorage('comment')->loadMultiple();
        foreach($entities as $item){
          $item->delete();
        }
      }

  }

  /**
  * remove all media which have list page testing
  * before running suite to allow list page tests to run
  * @BeforeSuite
  */
  public static function removeMediaData(BeforeSuiteScope $scope)
 {
     // Allow tester to bypass content deletion. This comes in handy when testing specific features or scenarios.
     // Tester can supply 'nodelete' after value provided for the name, tags, or role option.
     // Example: bin/behat --tags eventsandwebcasts,nodelete
     $deleteContent = true;
     try {
       $filterString = $GLOBALS['argv'][2];
       if (strpos($filterString, 'nodelete') !== false) {
         $deleteContent = false;
       }
     }
     catch (Exception $e) {
       $deleteContent = true;
     }

    $database = \Drupal::database();
    $storage_handler = \Drupal::entityTypeManager()->getStorage('media');

    $types = array('file');
    if ($deleteContent) {
      do {
        $mids_query = $database->select('media', 'm')
          ->fields('m', array('mid'))
          ->condition('m.bundle', $types, 'IN')
          ->range(0, 200)
          ->execute();

      $mids = $mids_query->fetchCol();
      $entities = $storage_handler->loadMultiple($mids);
      $storage_handler->delete($entities);
      } while (!empty($mids));
    }
 }
  /**
   * remove all node logging events
   * @BeforeScenario
   */
  public function clearNodeLogs()
  {
    $conn = \Drupal\Core\Database\Database::getConnection();
    if($conn->schema()->tableExists('node_log')){
      $conn->delete('node_log')->execute();
    }
  }

  /**
   * Call this function before nodes are created.
   *
   * @beforeNodeCreate
   */
  public function alterNodeObject(EntityScope $scope) {
    $node = $scope->getEntity();
    if (isset($node->field_start_date)) {
      $date = new DateTime($node->field_start_date);
      $node->field_start_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_end_date)) {
      $date = new DateTime($node->field_end_date);
      $node->field_end_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_publish_date)) {
      $date = new DateTime($node->field_publish_date);
      $node->field_publish_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_sec_event_date)) {
      $date = new DateTime($node->field_sec_event_date);
      $node->field_sec_event_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->field_sec_event_end_date)) {
      $date = new DateTime($node->field_sec_event_end_date);
      $node->field_sec_event_end_date = $date->format('Y-m-d H:i:s');
    }

    if (isset($node->published_at)) {
      $date = new DateTime($node->published_at);
      $node->published_at = $date->getTimestamp();
    }

    if (isset($node->created)) {
      $date = new DateTime($node->created);
      $node->created = $date->getTimestamp();
    }

    if (isset($node->changed)) {
      $date = new DateTime($node->changed);
      $node->changed = $date->getTimestamp();
    }

  }

  /**
   * Before nodeCreate check field value for file, if present create file and replace with fid
   * Field should be in format 'file;__file_source__;__file_name_
   * @beforeNodeCreate
   */
  public function nodeCreateAlter(EntityScope $scope) {
    $node = $scope->getEntity();
    $file_path = $this->getMinkParameter('files_path');
    $filesystem = \Drupal::service('file_system');

    foreach ($node as $key => $value) {
      if (strpos($value, 'file;') !== FALSE) {
        $file_info = explode(';', $value);
        $file_source = $file_info[1];
        $uri = $filesystem->copy(rtrim(realpath($file_path), DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.$file_source, "public://$file_source", FileSystem::EXISTS_REPLACE);
        File::create(['uri' => $uri])->save();
        $node->$key = $file_source;
      } elseif (strpos($value, 'image;') !== FALSE) {
        $file_info = explode(';', $value);
        $file_source = $file_info[1];
        $node->$key = rtrim(realpath($file_path), DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.$file_source;
      }
    }
  }

/**
 * This is a quick and dirty fix because publish_on MUST be an integer in order to even save the node in the step
 * 111 will set publish_on 5 minutes ago, 222 will set publish_on to +1 min, 333 will set publish_on to +1 hour
 * anything else will set to now.
 * @beforeNodeCreate
 */
public function alterPublishTime(EntityScope $scope)
{
  $node = $scope->getEntity();
  if (isset($node->publish_on)) {
    if ($node->publish_on == '111') {
      $futureTime = new DateTime("-5 minute");
    } elseif ($node->publish_on == '222') {
      $futureTime = new DateTime("+1 minute");
    } else if ($node->publish_on == '333') {
      $futureTime = new DateTime("+1 hour");
    } else {
      $futureTime = new DateTime("now");
    }
    $node->publish_on = $futureTime->getTimestamp();
  }
  if (isset($node->unpublish_on)) {
    if ($node->unpublish_on == '111') {
      $futureTime = new DateTime("-5 minute");
    } elseif ($node->unpublish_on == '222') {
      $futureTime = new DateTime("+1 minute");
    } else if ($node->unpublish_on == '333') {
      $futureTime = new DateTime("+1 hour");
    } else {
      $futureTime = new DateTime("now");
    }
    $node->unpublish_on = $futureTime->getTimestamp();
  }
}

  /**
   * Delete all files before each scenario so that duplicates are not created
   * @BeforeScenario
   */
  public static function removeStaticFiles(BeforeScenarioScope  $scope) {
    do {
      $database = \Drupal::database();
      $query = $database->select('file_managed', 'fm');
      $query->join('file_usage', 'fu', 'fm.fid = fu.fid');
      // Only delete file if its part of node and media entities
      $orGroup = $query->orConditionGroup()
        ->condition('fu.type', 'node', '=')
        ->condition('fu.type', 'media', '=');
      $andGroup = $query->andConditionGroup()
        ->condition($orGroup)
        ->condition('fm.status', 1, '=');
      $query->condition($andGroup);
      $query->fields('fm', ['fid', 'uri']);
      $query->fields('fu', ['type']);
      $query->range(0, 500);
      $result = $query->execute();
      $fids = [];
      foreach ($result as $file) {
        $fids[$file->fid] = $file->fid;
      }
      $files = \Drupal::service('entity_type.manager')->getStorage('file')->loadMultiple($fids);
      \Drupal::service('entity_type.manager')->getStorage('file')->delete($files);
    } while (!empty($fids));
  }

/**
 *
 * Clean up of nodes, users, etc. is automatic. But not Terms (or links!). This is a little hacky, all
 * new terms and menu links MUST be prepended with BEHAT.
 *
 * @AfterScenario
 */
public static function cleanupTerms() {
  $tids = \Drupal::entityQuery('taxonomy_term')
    ->condition('name', 'BEHAT', 'STARTS_WITH')
    ->execute();

  $controller = \Drupal::entityTypeManager()->getStorage('taxonomy_term');
  $entities = $controller->loadMultiple($tids);
  $controller->delete($entities);

  $mids = \Drupal::entityQuery('menu_link_content')
    ->condition('title', 'BEHAT', 'STARTS_WITH')
    ->execute();

  $mcontroller = \Drupal::entityTypeManager()->getStorage('menu_link_content');
  $mentities = $mcontroller->loadMultiple($mids);
  $mcontroller->delete($mentities);
}

/**
   * @Given I am on page :arg1
   */
  public function iAmOnPage($page)
  {
      $this->visitPath($page);
  }


  /**
   * @Then I should see the logo :arg1 in the header
   */
  public function iShouldSeeTheLogoInTheHeader($arg1)
  {
      throw new PendingException();
  }



  /**
   * @Then I should see the latest press releases in the :arg1 region
   */
  public function iShouldSeeTheLatestPressReleasesInTheRegion($arg1)
  {
	var_export($this);
      throw new PendingException();
  }

  /**
   * @Then I should see the last :arg1 Press Releases in the latest region
   */
  public function iShouldSeeTheLastPressReleasesInTheLatestRegion($arg1)
  {
    $latest = $this->getSession()->getPage()->findAll('css', '.newsroom-latest-pr .item-list ul li');
		$count = 0;

		foreach ($latest as $row) {
			$count++;
		}
		if ( $count == 5 ){
			return;
		}

		else {
			throw new \Exception(
			sprintf("Expected latest pr - %s not found on page %s",
				$arg1,
				$this->getSession()->getCurrentUrl())
			);
		}
  }


  /**
   * @Then I should see the menu :arg1 in the :arg2 region
   */
  public function iShouldSeeTheMenuInTheRegion($arg1, $arg2)
  {
      /*left nav mapping for list pages */
      $navmenu = (array("Newsroom"=>"#block-newsroomleftnav", "Speech"=>"#block-newsroomleftnav", "Fast Answers"=>"#block-investorinformationmenu-menu","Forms"=>"#block-filingsmenu",
	  "Data"=>"#block-about", "Investor Alerts"=>"#block-investorinformationmenu", "Reports"=>"#block-about"));

	$listnav = $this->getSession()->getPage()->find('css', 'nav');

	if (array_key_exists($arg1, $navmenu)){

		if ($listnav->findAll('css', $navmenu[$arg1])){
		  return;
		}

	}

	else {
		throw new \Exception(
		sprintf("Expected %s menu not found on page %s",
			$arg1,
			$this->getSession()->getCurrentUrl())
		);
	}
  }

  /**
   * Click on the element with the provided CSS Selector
   *
   * @Then /^I click on the element with css selector "([^"]*)"$/
   */
  public function iClickOnTheElementWithCSSSelector($cssSelector)
  {
      $element = $this->getSession()->getPage()->find("css", $cssSelector);
      if (null === $element) {
          throw new \InvalidArgumentException(sprintf('Could not evaluate CSS Selector: "%s"', $cssSelector));
      }

      $element->click();

  }
  /**
   * @Given /^I wait (\d+) seconds$/
   */
  public function iWaitSeconds($seconds)
  {
      sleep($seconds);
  }

  /**
  * Input and select into an autocomplete field
  * @When I select the first autocomplete option for :text on the :autocomplete field
  */
  public function iSelectTheFirstAutocompleteOptionForTextOnTheAutocompleteField($autocomplete, $text)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();
    $field = $this->getSession()->getPage()->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $driver->keyDown($xpath, 40);
    $driver->keyUp($xpath, 40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
       throw new \Exception("Autocomplete result not found");
    } else {
      $result->click();
    }
  }

  /**
   * Input and select into an autocomplete field
   * @When I select the autocomplete option for :text on the :autocomplete field
   */
  public function iSelectTheAutocompleteOptionForTextOnTheAutocompleteField($autocomplete, $text)
  {
    $session = $this->getSession();
    $driver = $session->getDriver();
    $field = $this->getSession()->getPage()->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $driver->keyDown($xpath, 40);
    $driver->keyUp($xpath, 40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
       throw new \Exception("Autocomplete result not found");
    } else {
      $driver->keyDown($xpath, 40);
      $driver->keyDown($xpath, 9);
    }
  }

  //
  /**
   * @When I fill in :arg1 field with :arg2
   */
  public function iFillInFieldWith($arg1, $arg2)
  {
    $this->getSession()->executeScript('jQuery("#'.$arg1.'").val("'.$arg2.'")');
  }

  /**
  * Input and select into an autocomplete field
  * @When I select the first autocomplete option for :text on the :autocomplete field on a modal
  * I think there's a way to clean this up, pass an optional field of region to the function above
  * and then add the matching step as well. I'll need to look into that TODO
  */
  public function iSelectTheFirstAutocompleteOptionForTextOnTheAutocompleteFieldOnAModal($autocomplete, $text)
  {
    $region = "modal";
    $session = $this->getSession();
    $driver = $session->getDriver();
    $regionObj = $session->getPage()->find('region', $region);
    if (!$regionObj) {
      throw new \Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
    }
    $field = $regionObj->findField($autocomplete);
    $field->focus();

    $this->scrollIntoView("#" . $field->getAttribute("id"));

    // Set the autocomplete text then put a space at the end which triggers
    // the JS to go do the autocomplete stuff.
    $field->setValue($text);
    $xpath = $field->getXpath();
    $field->keyDown(40);
    $field->keyUp(40);

    // Wait for AJAX to finish.
    $this->minkContext->iWaitForAjaxToFinish();

    $result = $this->getSession()->getPage()->find("xpath", "//ul[not(contains(@style,'display: none'))]/li[@class='ui-menu-item']/a");
    if (empty($result)) {
       throw new \Exception("Autocomplete result not found");
    } else {
      $result->click();
    }
  }

  /**
   * @Then I click :buttonName on the modal :title
   */
  public function iClickButtonOnTheModal($buttonName, $title)
  {
      $modals = $this->getSession()->getPage()->findAll('css', '.ui-dialog');
      if (!empty($modals)) {
        foreach ($modals as $modal) {
          $modalTitle = $modal->find("css", ".ui-dialog-title");
          if ($modal && $modal && $modal->isVisible() && trim($modalTitle->getText()) === $title) {

            //now find the button
            $buttons = $modal->findAll("css", ".button");
            if (!empty($buttons)) {
              foreach ($buttons as $button) {
                if ($button && $button->isVisible() && trim($button->getText()) === $buttonName) {
                  $button->click();
                  $this->minkContext->iWaitForAjaxToFinish();
                }
              }
            }
          }
        }
      }
  }

  /**
   * @Then /^I should see the modal "([^"]*)"$/
   */
  public function iShouldSeeTheModal($title)
  {
    $this->getSession()->wait(20000, '(0 === jQuery.active && 0 === jQuery(\':animated\').length)');
    $modal = $this->getSession()->getPage()->find('css', '.ui-dialog-title');
    if ($modal && $modal->isVisible() && trim($modal->getText()) === $title) {
      return;
    }

    throw new \Exception(sprintf("Modal %s not found", $title));
  }

  /**
 * A function that will allow users to set an option in the drop down publish
 * button on a node create/edit page. Searches by the value of the input.
 *
 * @Given I click the input with the value :arg1
 */
  public function iClickTheInputWithTheValue($arg1)
  {
    $xpath = '//input[@value="' . $arg1 . '"]';
    $pubButton = $this->getSession()->getPage()->findAll('xpath', $xpath);
    if ($pubButton != null){
      $pubButton[0]->click();
      return;
    } else {
      throw new \Exception(
        sprintf("Expected %s option not found on node", $arg1)
      );
    }
  }

 /**
   * @Given I publish it
   */
  public function iPublishIt()
  {
	//publishing status checkbox is hidden unless moderation is not available
    if(empty($this->assertSession()->elementExists('css', '.moderation-state-published'))) {
      $this->getSession()->getPage()->checkField('edit-status-value');
    }

    try {
      $this->getSession()->getPage()->pressButton('List additional actions');
      //check upper and lower case p
	  try {
    	   $this->iClickTheInputWithTheValue("Save and publish");
      } catch (Exception $e) {
        $this->iClickTheInputWithTheValue("Save and Publish");
      }
    } catch  (Exception $f)  {
	  //If list addtional actions cannot be clicked
      try {
    	   $this->iClickTheInputWithTheValue("Save and publish");
      } catch (Exception $g) {
        $this->iClickTheInputWithTheValue("Save and Publish");
      }
    }
  }

  /**
   * This depends on W3Cs online validator, if you can't reach the internet or they change it
   * this will break
   *
   * @Then I should see valid XML
   */
  public function iShouldSeeValidXml()
  {
    $feed = $this->getSession()->getDriver()->getContent();
    $url = 'https://validator.w3.org/feed/check.cgi';
    $data = array('rawdata' => $feed, 'manual' => 1);
    $options = array(
            'http' => array(
            'header'  => "Content-type: application/x-www-form-urlencoded\r\n",
            'method'  => 'POST',
            'content' => http_build_query($data),
        )
    );
    $context  = stream_context_create($options);
    $result = file_get_contents($url, false, $context);
    if (stristr($result , 'Congratulations') !== false) {
      return;
    } else {
      throw new \Exception("Feed is not valid XML");
    }
  }

  /**
   * @Then I should see the :arg1 in the :arg2 player
   */
  public function iShouldSeeTheInThePlayer($url, $type)
  {
    //get id from vimeo or youtube
    // and build player name for vimeo or youtube
    $id = null;
    switch($type) {
      case "YouTube":
        $parts = explode("=", $url);
        $id = $parts[1];
        $src = "https://www.youtube.com/embed/" . $id . "?autoplay=0&start=0&rel=0";
        break;
      case "Vimeo":
        $parts = explode("/", $url);
        $id = end($parts);
        $src = "https://player.vimeo.com/video/" . $id . "?autoplay=0";
        break;
    }

    //return if player name appears in responsive div iframe src attribute
    $xpath = '//div[contains(@class, "video-embed-field-responsive-video")]/iframe';
    $iFrame = $this->getSession()->getPage()->findAll('xpath', $xpath);
    $iFrameSrc = $iFrame[0]->getAttribute('src');
    if ($iFrameSrc == $src) {
      return;
    } else {
      throw new \Exception($src . " not found in Video Embed Field Responsive Video");
    }
  }

  /**
   * @Then the link :arg1 should match the Drupal url :arg2
   */
  public function theLinkShouldMatchTheDrupalUrl($link, $url)
  {
      $linkHandle = $this->getSession()->getPage()->find('named', array('link', $link));
      if (isset($linkHandle)) {
        $linkUrl = $linkHandle->getAttribute('href');
        $root = explode('.', $link, -1);
        $file_path = explode('/', $url, -1);
        $filePieces = explode('.', $link);
        $extension = end($filePieces);
        $escaped = preg_quote($root[0], '/');
        $url_path = $file_path[1] . "/" . $file_path[2] . "/";
        $escaped_path = preg_quote($url_path, '/');
        $pattern = '/\/' . $escaped_path . '.*' . $escaped . '_*\d*' . '.' . $extension . '/';
        if (preg_match($pattern, $linkUrl)) {
          return;
        } else {
          throw new \Exception($link . " link does not match the Drupal Url " . $linkUrl);
        }
      } else {
        throw new \Exception($link . " link not found on page.");
      }
  }

  /**
   * @Then the hyperlink :arg1 should match the Drupal url :arg2
   */
  public function linkShouldMatchTheDrupalUrl($link, $url)
  {
      $linkHandle = $this->getSession()->getPage()->find('named', array('link', $link));
      if (isset($linkHandle)) {
        $linkUrl = $linkHandle->getAttribute('href');
        if (strcmp($url, $linkUrl) == 0) {
          return;
        } else {
          throw new \Exception($link . " link does not match the Drupal Url " . $linkUrl);
        }
      } else {
        throw new \Exception($link . " link not found on page.");
      }
  }

  /**
  * @Then the image src in the :arg1 region should match the Drupal url :arg2
  */
   public function theImageSrcInTheRegionShouldMatchTheDrupalUrl($region, $url)
   {
     $session = $this->getSession();
     $regionObj = $session->getPage()->find('region', $region);
     if (!$regionObj) {
       throw new \Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
     }
     $elements = $regionObj->findAll('css', 'img');
     if (empty($elements)) {
       throw new \Exception(sprintf('The element "img" was not found in the "%s" region on the page %s', $region, $this->getSession()->getCurrentUrl()));
     }
     $found = FALSE;
     foreach ($elements as $element) {
       $attr = $element->getAttribute("src");
       if (!empty($attr)) {
         $found = TRUE;
         $root = explode('.', $url, -1);
         $filePieces = explode('.', $url);
         $extension = end($filePieces);
         $escaped = preg_quote($root[0], '/');
         $pattern = '/' . $escaped . '_*\d*' . '.' . $extension . '/';
         if (!preg_match($pattern, $attr)) {
           throw new \Exception(sprintf('The "src" attribute does not equal "%s" on the element "img" in the "%s" region on the page %s', $url, $region, $this->getSession()->getCurrentUrl()));
         }
         break;
       }
     }
     if (!$found) {
       throw new \Exception(sprintf('The "src" attribute is not present on the element "img" in the "%s" region on the page %s', $region, $this->getSession()->getCurrentUrl()));
     }
   }

   /**
    * @When I drag menu link :arg1 onto :arg2
    */
   public function iDragOnto($arg1, $arg2)
   {
      $page = $this->getSession()->getPage();
      $dragged = $page->find('xpath', '//a[text()="' . $arg1 . '"]/preceding-sibling::a');
      $target = $page->find('xpath', '//a[text()="' . $arg2 . '"]/ancestor::tr');


      $session = $this->getSession()->getDriver()->getWebDriverSession();

      $from = $session->element('xpath',$dragged->getXpath());
      $to = $session->element('xpath',$target->getXpath());

      $session->moveto(array('element' => $from->getID()));
      $session->buttondown("");
      $session->moveto(array('element' => $to->getID()));
      $session->buttonup("");
   }

   /**
    * @When I drag announcement :arg1 onto :arg2
    */
   public function iDragAnnouncementOnto($arg1, $arg2)
   {
      $page = $this->getSession()->getPage();

      $dragged = $page->find('xpath', '//tr/td[contains(., "' . $arg1 . '")]/preceding-sibling::td/a');
      $target = $page->find('xpath', '//tr/td[contains(., "' . $arg2 . '")]/ancestor::tr');

      $session = $this->getSession()->getDriver()->getWebDriverSession();

      $from = $session->element('xpath',$dragged->getXpath());
      $to = $session->element('xpath',$target->getXpath());

      $session->moveto(array('element' => $from->getID()));
      $session->buttondown("");
      $session->moveto(array('element' => $to->getID()));
      $session->buttonup("");
   }

   /**
    * @When I drag highlight :arg1 onto :arg2
    */
   public function iDragHighlightOnto($arg1, $arg2)
   {
      $page = $this->getSession()->getPage();
      $dragged = $page->find('xpath', '//tr/td[contains(., "' . $arg1 . '")]/preceding-sibling::td/a');
      $target = $page->find('xpath', '//tr/td[contains(., "' . $arg2 . '")]/ancestor::tr');


      $session = $this->getSession()->getDriver()->getWebDriverSession();

      $from = $session->element('xpath',$dragged->getXpath());
      $to = $session->element('xpath',$target->getXpath());

      $session->moveto(array('element' => $from->getID()));
      $session->buttondown("");
      $session->moveto(array('element' => $to->getID()));
      $session->buttonup("");
   }

//tr/td[contains(@headers, 'view-title-table-column')]/text()

   /**
    * @Given I click secondary option :arg1
    */
   public function iClickSecondaryOption($arg1)
   {
     $xpath = "//summary/span[text() = '" . $arg1 . "']";
     $secondaryOption = $this->getSession()->getPage()->findAll('xpath', $xpath);
     $this->scrollIntoView($xpath);
     $secondaryOption[0]->click();
   }

 /**
  * @When I scroll :selector into view
  *
  * @param string $selector Allowed selectors: #id, .className, //xpath
  *
  * @throws \Exception
  */
 public function scrollIntoView($selector)
 {
     $locator = substr($selector, 0, 1);

     switch ($locator) {
         case '/' : // XPath selector
             $function = <<<JS
(function(){
var elem = document.evaluate("$selector", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
elem.scrollIntoView(false);
})()
JS;
             break;

         case '#' : // ID selector
             $selector = substr($selector, 1);
             $function = <<<JS
(function(){
var elem = document.getElementById("$selector");
elem.scrollIntoView(false);
})()
JS;
             break;

         case '.' : // Class selector
             $selector = substr($selector, 1);
             $function = <<<JS
(function(){
var elem = document.getElementsByClassName("$selector");
elem[0].scrollIntoView(false);
})()
JS;
             break;
         default:
             throw new \Exception(__METHOD__ . ' Couldn\'t find selector: ' . $selector . ' - Allowed selectors: #id, .className, //xpath');
             break;
     }

     try {
         $this->getSession()->executeScript($function);
     } catch (Exception $e) {
         throw new \Exception(__METHOD__ . ' failed');
     }
 }
  /**
	* @Then I play the video
	*/
  public function iPlayTheVideo() {
	sleep(1);
		$isPlaying= $this->getSession()->getPage()->find('css','.akamai-playing, .vjs-playing');
		if (!$isPlaying) {
			$video = $this->getSession()->getPage()->find('css', '.akamai-video, .limelight-player');
			if ($video && $video->isVisible()) {
				$playButton = $this->getSession()->getPage()->find('css', '.vjs-play-control,.akamai-play-pause');
				if ($playButton && $playButton->isVisible()) {
					$playButton->click();
				} else {
					$video->click();
				}
			}
		}
	}


  /**
   * @Then I should see the video playing
   */
  public function iShouldSeeTheVideoPlaying()
  {
  	$video = $this->getSession()->getPage()->find('css', '.vjs-playing, .akamai-playing');
  	if ($video && $video->isVisible()) {
  		return;
  	}

  	throw new \Exception(sprintf("video player not found"));
  }

  /**
  * @Then I should see a video player
  */
  public function iShouldSeeAVideoPlayer()
  {
    sleep(9);
    $video = $this->getSession()->getPage()->find('css', '.videoplayer, .wowza-player, .youtube-video, .vimeo-video');
    if ($video && $video->isVisible()) {
      return;
    }
    throw new \Exception(sprintf("video player not found"));
  }

 /**
  * @Given I run drupal cron
  */
 public function iRunDrupalCron()
 {
    $this->visitPath("/cron/_r2KGyLALoO2Ui_HnSyGdAG7iHf3nrXG0i7FHFSIP2HtMVtytaGnQetEIfTgChFmI5LDzs13lg");
 }

 /**
 * @When I fill in :arg1 in the :arg2 session :arg3 :arg4
 */
public function iFillInInTheSessionStartDate($arg1, $arg2, $arg3, $arg4)
{
  $field = "field_session[" . --$arg2 . "][subform][field_" . $arg3 . "_date][0][value][" . $arg4 . "]";
  $this->getSession()->executeScript('jQuery("input[name=\''.$field.'\']").val("'.$arg1.'")');
}

/**
 * @When I fill in :arg1 in the :arg2 event :arg3 date
 */
public function iFillInInTheEventStartDate($arg1, $arg2, $arg3)
{
    $field = "field_session[" . --$arg2 . "][subform][field_" . $arg3 . "_date][0][value]";
    $this->getSession()->executeScript('jQuery("input[name=\''.$field.'\']").val("'.$arg1.'")');
}

/**
 * @When I fill in :arg1 in the :arg2 dynamic event :arg3 date
 */
public function iFillInInTheDynamicEventStartDate($arg1, $arg2, $arg3)
{
    $field = "field_session[" . --$arg2 . "][subform][field_" . $arg3 . "_date][0][value]";
    // changing date format
    $date = new DateTime($arg1);
    $text = $date->format('Y-m-d h:i:s A');
    $this->getSession()->executeScript('jQuery("input[name=\''.$field.'\']").val("'.$text.'")');
}

/**
 * @Then I should see response headers with content type :arg1
 */
public function iShouldSeeResponseHeadersWithContentType($arg1)
{
  switch (strtolower($arg1)) {
    case "pdf":
      $type = "application/pdf";
      break;
    default:
      throw new \Exception(sprintf("Content Type Not Defined. Update FeatureContext."));

  }

  $headers = $this->getSession()->getResponseHeaders();
  $content_type =  $headers['Content-Type'];
  assert($content_type[0] == $type);
}

/**
 * @Then I should see response headers with inline content type :arg1
 */
public function iShouldSeeResponseHeadersWithContentTypeAndInlineDisposition($arg1)
{
  switch (strtolower($arg1)) {
    case "pdf":
      $type = "application/pdf";
      break;
    default:
      throw new \Exception(sprintf("Content Type Not Defined. Update FeatureContext."));

  }

  $headers = $this->getSession()->getResponseHeaders();
  $content_type =  $headers['Content-Type'];
  assert($content_type[0] == $type);

  $disposition = explode(';', $headers['Content-Disposition'][0]);
  $inline = $disposition[0] == 'inline' ? TRUE : FALSE;
  assert($inline);
}

/**
 * Fills in specified field with date
 * Example: When I fill in "field_ID" with date "now"
 * Example: When I fill in "field_ID" with date "-7 days"
 * Example: When I fill in "field_ID" with date "+7 days"
 * Example: When I fill in "field_ID" with date "-/+0 weeks"
 * Example: When I fill in "field_ID" with date "-/+0 years"
 *
 * @When /^(?:|I )fill in "(?P<field>(?:[^"]|\\")*)" with date "(?P<value>(?:[^"]|\\")*)"$/
 */
public function fillDateField($field, $value)
{
    $newDate = strtotime("$value");

    $dateToSet = date("Y-m-d", $newDate);
    $this->getSession()->executeScript('jQuery("input[id=\''.$field.'\']").val("'.$dateToSet.'")');
}

/**
 * @When /^the link should open in a new tab$/
 */
public function linkShouldOpenInNewTab()
{
    $session     = $this->getSession();
    $windowNames = $session->getWindowNames();
    if(sizeof($windowNames) < 2){
        throw new \ErrorException("Expected to see at least 2 windows opened");
    }

    //Switch to that window
    $session->switchToWindow($windowNames[1]);
}

/**
 * @When /^I clear drupal cache$/
 */
public function clearDrupalCache()
{
    $this->visitPath("/admin/config/development/performance");
    $this->getSession()->getPage()->pressButton('edit-clear');

}

/**
 * @When I scroll to the bottom
 */
public function iScrollToThe()
{
  $this->getSession()->wait(500,' window.scrollTo(0, document.body.scrollHeight) ');
}

/**
 * @When I scroll to the top
 */
public function iScrollUp()
{
  $this->getSession()->wait(500,' window.scrollTo(0, 0) ');
}

/**
   * @When I drag image :arg1 onto :arg2
   */
  public function iDragImageOnto($arg1, $arg2)
  {
     $page = $this->getSession()->getPage();
     $dragged = $page->find('xpath', '//tbody/tr/td[contains(., "' . $arg1 . '")]/preceding-sibling::td/a');
     $target = $page->find('xpath', '//tbody/tr/td[contains(., "' . $arg2 . '")]/ancestor::tr');


     $session = $this->getSession()->getDriver()->getWebDriverSession();

     $from = $session->element('xpath',$dragged->getXpath());
     $to = $session->element('xpath',$target->getXpath());

     $session->moveto(array('element' => $from->getID()));
     $session->buttondown("");
     $session->moveto(array('element' => $to->getID()));
     $session->buttonup("");
  }

  /**
   * Switches focus to an iframe.
   *
   * @Given /^I switch (?:away from|to) the iframe "([^"]*)"$/
   * @param string $iframe_id
   */
  public function iSwitchToTheIframe($iframe_id) {
    if ($iframe_id) {
      $this->getSession()->switchToIFrame($iframe_id);
    } else {
      $this->getSession()->switchToIFrame();
    }
  }

  /**
    * @Given /^I close the current (?:window|tab)$/
    */
  public function closeCurrentWindow()
  {
     $session     = $this->getSession();
     $this->getSession()->executeScript("window.open('','_self').close();");
     $session->stop();
  }

  /**
   * @When I delete the file :arg1 from the file system
   */
  public function iDeleteFileFromFileSystem($arg1)
  {
    if (substr($arg1, 0, 1) === '/') {
      $arg1 = substr($arg1, 1, strlen($arg1) - 1);
    }
    unlink(DRUPAL_ROOT . '/' . $arg1);
  }

  /**
   * @Then /^Radio button with id "([^"]*)" should be checked$/
   */
  public function RadioButtonWithIdShouldBeChecked($sId)
  {
    $elementByCss = $this->getSession()->getPage()->find('css', 'input[type="radio"]:checked#'.$sId);
    if (!$elementByCss) {
        throw new Exception('Radio button with id ' . $sId.' is not checked');
    }
  }

  /**
   * Ensure that an HTML element exists on the page
   *
   * @Then I should see the html element :arg1 on the page
   */
  public function iSeeTheHtmlElementOnPage($arg1)
  {
    $element = $this->getSession()->getPage()->find("css", $arg1);

    if (!$element) {
      throw new \Exception("element $arg1 was not found on the page.");
    }
  }

  /**
   * Ensure that an HTML element does not exists on the page
   *
   * @Then I should not see the html element :arg1 on the page
   */
  public function iDoNotSeeTheHtmlElementOnPage($arg1)
  {
    $element = $this->getSession()->getPage()->find("css", $arg1);

    if ($element) {
      throw new \Exception("element $arg1 was found on the page.");
    }
  }

  /**
   * Check that a link is hidden with css on the page.
   *
   * @Then the :link link should be hidden
   */
  public function theLinkShouldBeHidden($link) {
    $session = $this->getSession();
    $page = $session->getPage();

    $link = $page->find("xpath", "//a[contains(.//span,'" . $link . "')]");

    if ($link->isVisible()) {
      throw new \LogicException('The link should not be visible.');
    }
  }

  /**
   * @Then the :tag element with ID :id should not be set
   */
  public function publishedOnValueShouldNotBeSet($tag, $id) {
    $page = $this->getSession()->getPage();
    $inputElement = $page->find("xpath", "//" . $tag . "[@id='". $id . "']");
    $emptyInputElement = $page->find("xpath", "//" . $tag . "[@id='". $id . "' and @value]");

    if ($inputElement === NULL) {
      throw new \Exception('No' . $tag . 'field with ID ' . $id . ' was found on the page');
    }
    elseif ($emptyInputElement === NULL) {
      throw new \Exception('The value should not be set.');
    }
  }

  /**
   * @When I switch to the main window
   */
  public function iSwitchToTheMainWindow()
    {
      $this->getSession()->switchToIframe();
    }

    /**
    * The path where mail can be rerieved
    *
    * $mailpath string
    *
    */
    protected $mailpath = "http://mail-exchange.lndo.site";

    /**
    * @Given /^I check notification$/
    */
    public function iCheckNotification()
    {
    $mail_path = $this->mailpath;
    $this->visitPath($mail_path);
    }

    /**
     * Input and view list of autocomplete field with region
     * @When I view the linkit autocomplete option for :text on the :autocomplete field in the :region region
     */
    public function iViewTheLinkItAutocompleteOptionForTextOnTheAutocompleteFieldRegion($autocomplete, $text, $region)
    {
      $session = $this->getSession();
      $driver = $session->getDriver();
      $regionNode = $session->getPage()->find('region', $region);
      if (!$regionNode) {
        throw new Exception(sprintf('No region "%s" found on the page %s.', $region, $session->getCurrentUrl()));
      }
      $field = $regionNode->findField($autocomplete);
      $field->focus();

      $this->scrollIntoView("#" . $field->getAttribute("id"));

      // Set the autocomplete text then put a space at the end which triggers
      // the JS to go do the autocomplete stuff.
      $field->setValue($text);
      $xpath = $field->getXpath();
      $driver->keyDown($xpath, 40);
      $driver->keyUp($xpath, 40);
    }

   /**
   * @When I check :arg1 on the files selector
   * arg2 is the iFrame name, contacts and files both use an iFrame
   */
    public function iCheckOnTheFilesSelector($arg1)
    {
      $field = $this->getSession()->getPage()->find("xpath", "//td[contains(., '" . $arg1 . "')]/preceding-sibling::td/div/input");
      if (empty($field)) {
        throw new \Exception("Checkbox not found");
      } else {
        $field->check();
      }
    }

   /**
	 * @Then I should see :textA followed by :textB
	 */
  public function iShouldSeeFollowedBy($textA, $textB)
  {
    $content = $this->getSession()->getPage()->getContent();

    // Get rid of stuff between script tags
    $content = $this->removeContentBetweenTags('script', $content);

    // ...and stuff between style tags
    $content = $this->removeContentBetweenTags('style', $content);

    $content = preg_replace('/<[^>]+>/', ' ',$content);

    // Replace line breaks and tabs with a single space character
    $content = preg_replace('/[\n\r\t]+/', ' ',$content);

    $content = preg_replace('/ {2,}/', ' ',$content);

    if (strpos($content,$textA) === false) {
      throw new Exception(sprintf('"%s" was not found in the page', $textA));
    }

    $seeking = $textA . ' ' . $textB;
    if (strpos($content,$textA . ' ' . $textB) === false) {
      // Be helpful by finding the 10 characters that did follow $textA
      preg_match('/' . $textA . ' [^ ]+/',$content,$matches);
      throw new Exception(sprintf('"%s" was not found, found "%s" instead', $seeking, $matches[0]));
    }
  }
}
