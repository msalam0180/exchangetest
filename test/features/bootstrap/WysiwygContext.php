<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Tester\Exception\PendingException;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

/**
 * Defines application features from the specific context.
 */
class WysiwygContext extends RawDrupalContext implements Context {

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
   * Get a Mink Element representing the WYSIWYG toolbar.
   *
   * @throws Exeception
   *   Throws an exception if the toolbar can't be found.
   *
   * @return \Behat\Mink\Element\NodeElement
   *   The toolbar DOM Node.
   */
  protected function getWysiwygToolbar($label = 'Body') {
    $id = $this->getWysiwygId($label);
    $driver = $this->getSession()->getDriver();

    $toolbarElement = $driver->find("//div[@id='cke_" . $id . "']");
    $toolbarElement = !empty($toolbarElement) ? $toolbarElement[0] : NULL;

    if (!$toolbarElement) {
      throw new \Exception(sprintf('Toolbar for %s editor was not found on the page %s', $label, $this->getSession()->getCurrentUrl()));
    }

    return $toolbarElement;
  }

  /**
   * Get id of WYSIWYG element by label text
   *
   * @param String
   * The label associated with the WYSIWYG NodeElement
   *
   * @return String
   * The id attribute of the WYSIWYG NodeElement
   */

  protected function getWysiwygId($label) {
    // Traverse page content matching $label. The first label found, get the for
    // attribute as this is the id of the WYSIWYG field.
    $id = '';
    $page = $this->getSession()->getPage();
    // Search for content containing $label
    $nodeElements = $page->findAll('named', array('content', $label));
    foreach ($nodeElements as $el) {
      if ($el->getTagName() == 'label') {
        $id = $el->getAttribute('for');
        // Make sure NodeElement is a textarea
        if ($page->find('css', '#' . $id)->getTagName() == 'textarea') {
          break;
        }
      }
    }
    return $id;
  }

  /**
   * @When I type :arg1 in the :arg2 WYSIWYG editor
   */
  public function iTypeInTheWysiwygEditor($text, $arg2)
  {
    $id = $this->getWysiwygId($arg2);
    $this->getSession()->executeScript("CKEDITOR.instances['" . $id . "'].insertText('$text');");
  }

  /**
   * @When I type :arg1 in the :arg2 session :arg3 WYSIWYG editor
   */
  public function iTypeInTheSessionWysiwygEditor($text, $arg2, $arg3)
  {
      $fieldName = "field_session[" . --$arg2 . "][subform][field_" . strtolower($arg3) . "][0][value]";
      $field = $this->getSession()->getPage()->findField($fieldName);
      $id = $field->getAttribute('id');
      $this->getSession()->executeScript("CKEDITOR.instances['$id'].insertText('$text');");
  }

  /**
   * @When I press :arg1 in the WYSIWYG Toolbar
   * Likely I'm going to have to abstract this at some point too if we have to test that a field like transcript can bold
   * italic etc. I'm going to wait until that time comes.
   */
  public function iPressInTheWysiwygToolbar($arg1)
  {
    $driver = $this->getSession()->getDriver();
    $toolbarElement = $this->getWysiwygToolbar();

    // Click the action button.
    $button = $toolbarElement->find("xpath", "//a[starts-with(@data-drupal-title, '$arg1')]");
    $button->click();
    $this->minkContext->iWaitForAjaxToFinish();
  }

  /**
   * @When I copy html within css selector :arg1 into :arg2
   */
  public function iCopyHtmlWithinCssSelectorInto($arg1,$arg2) {

    $copy = $this->getSession()->getPage()->find('css', $arg1)->getText();

    $copiedText = $this->getSession()->getDriver()->evaluateScript(
      'function(){
        sessionStorage.setItem("'.$arg2.'", "'.htmlspecialchars($copy).'");
      }()'
    );

  }

  /**
   * @When I paste :arg1 in css selector :arg2
   */
  public function iPasteHtmlInCssSelector($arg1, $arg2) {
    $copiedText = $this->getSession()->getDriver()->evaluateScript(
         'function(){
           return sessionStorage.getItem("'.$arg1.'");
         }()'
       );
       $copiedText = html_entity_decode($copiedText);
       $copy = $this->getSession()->getPage()->find('css', $arg2);
       $copy->setValue($copiedText);
  }

  /**
   * @When I add html :arg1 and :arg2 into css selector :arg3
   */
  public function iAddTextTo($arg1,$arg2,$arg3) {
    $copy = $this->getSession()->getPage()->find('css', $arg3);
    $copiedText = $this->getSession()->getDriver()->evaluateScript(
         'function(){
           return sessionStorage.getItem("'.$arg1.'").concat(sessionStorage.getItem("'.$arg2.'"));
         }()'
       );
     $copiedText = html_entity_decode($copiedText);
     $copy->setValue($copiedText);
  }

    /**
   * @When I press :arg1 in the :arg2 WYSIWYG Toolbar
   * Likely I'm going to have to abstract this at some point too if we have to test that a field like transcript can bold
   * italic etc. I'm going to wait until that time comes.
   */
  public function iPressInTheWysiwygToolbarButton($arg1, $arg2)
  {
    $toolbarElement = $this->getWysiwygToolbar($arg2);

    // If the element is 'link', we need to set focus
    if ($arg1 == 'Link') {
      $id = $this->getWysiwygId($arg2);
      $script = <<<"EOT"
        var editor = CKEDITOR.instances['$id'];
        var element = editor.document.getElementsByTag('p');
        editor.getSelection().selectElement(element.getItem(0));
EOT;
      $this->getSession()->executeScript($script);
    }

    // Click the action button.
    $button = $toolbarElement->find("xpath", "//a[starts-with(@data-drupal-title, '$arg1')]");
    $button->click();
    $this->minkContext->iWaitForAjaxToFinish();
  }

  /**
   * @When I type :arg1 in css selector :arg2
   */
  public function iTypeInCssSelector($arg1, $arg2) {
    $copy = $this->getSession()->getPage()->find('css', $arg2);
    $copy->setValue($arg1);
  }

  /**
   * @When I take a screenshot using :feature file with :case tag
   */
  public function iTakeAScreenshotUsingFileWithTag($feature, $case)
  {
    if (strpos(getcwd(), 'docroot') == true) {
      chdir('../test/features/cucumber_wdio');
    }
    shell_exec('npm start ' . $feature . ' -- --cucumberOpts.tagExpression=' . $case);
  }
}
