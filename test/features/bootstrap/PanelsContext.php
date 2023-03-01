<?php
/**
 * @file
 * Contains \PanelsSubContext.
 */
use Behat\Mink\Element\NodeElement;
use Behat\Mink\Exception\ExpectationException;
use Drupal\DrupalExtension\Context\DrupalSubContextBase;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\MinkExtension\Context\MinkContext as Mink;
/**
 * Contains step definitions for working with Panels and panelized pages.
 */
class PanelsContext extends RawDrupalContext {
  /**
   * The Mink context.
   *
   * @var \Drupal\DrupalExtension\Context\MinkContext
   */
  protected $minkContext;
  /**
   * Pre-scenario hook.
   *
   * @BeforeScenario
   */
  public function gatherContexts() {
    $this->minkContext = $this->getSession()->getPage();
  }
  /**
   * Applies Panelizer to a node type.
   *
   * @param string $bundle
   *   The node type ID.
   *
   * @Given I have applied Panelizer to the :bundle node type
   * @Given I have panelized the :bundle node type
   *
   * @When I apply Panelizer to the :bundle node type
   * @When I panelize the :bundle node type
   */
  public function panelize($bundle) {
    $this->minkContext->assertAtPath("admin/structure/types/manage/$bundle/display");
    $this->minkContext->checkOption('panelizer[enable]');
    $this->minkContext->checkOption('panelizer[custom]');
    $this->minkContext->pressButton('Save');
  }
  /**
   * Removes Panelizer from a node type.
   *
   * @param string $bundle
   *   The node type ID.
   *
   * @Given I have removed Panelizer from the :bundle node type
   * @Given I have unpanelized the :bundle node type
   *
   * @When I remove Panelizer from the :bundle node type
   * @When I unpanelize the :bundle node type
   */
  public function unpanelize($bundle) {
    $this->minkContext->assertAtPath("admin/structure/types/manage/$bundle/display");
    $this->minkContext->uncheckOption('panelizer[enable]');
    $this->minkContext->uncheckOption('panelizer[custom]');
    $this->minkContext->pressButton('Save');
  }
  /**
   * Changes the layout of an IPE controlled entity via the IPE.
   *
   * @param string $category
   *   The layout's category.
   * @param string $layout_id
   *   The layout's data-layout-id value.
   *
   * @When I change the layout to :layout_id from the :category category
   */
  public function changeLayout($category, $layout_id) {
    $this->clickElementBySelector('a[title = "Change Layout"]');
    $this->getSession()->wait(500, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    $this->clickElementBySelector('a[data-category = "' . $category . '"]');
    $this->minkContext->iWaitForAjaxToFinish();
    $this->clickElementBySelector('a[data-layout-id = "' . $layout_id . '"]');
    $this->minkContext->iWaitForAjaxToFinish();
  }
  /**
   * Places a block into a panelizer layout via Wizard.
   *
   * @param string $label
   *   The text name of the block.
   * @param string $region
   *   The name of the region in which to place the block.
   *
   * @When I place the :type type :label block into the :region panelizer region
   */
  public function placePanelizerBlock($type, $label, $region) {
    $this->minkContext->clickLink('Manage Content');
    $this->getSession()->wait(5000, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    $customLink = $this->minkContext->find('xpath', '//a[contains(@data-category,"' . $type . '")]');
    $customLink->click();
    $this->getSession()->wait(5000, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    $this->minkContext->clickLink($label);
    $this->getSession()->wait(5000, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    sleep(2);
    $page = $this->getSession()->getPage();
    $regionField = $page->findField('Region');
    if (!isset($regionField)) {
      throw new \Exception("Could not find Region field");
    }
    $regionField->selectOption($region);
    $this->getSession()->wait(5000, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    $this->minkContext->pressButton('Add');
    $this->getSession()->wait(50000, '(typeof(jQuery)=="undefined" || (0 === jQuery.active && 0 === jQuery(\':animated\').length))');
    //$this->assertPanelizerBlock($label, $region);
  }

  /**
   * Asserts that a block is present in a specific region of a Panelizer layout.
   *
   * @param string $label
   *   The block label.
   * @param string $region
   *   The machine name of the region in which the block is expected to be.
   *
   * @return \Behat\Mink\Element\NodeElement
   *   The block's row in the table.
   *
   * @throws \Behat\Mink\Exception\ExpectationException
   *   If the block is not present as expected.
   *
   * @Then the :label block should be in the :region region
   */
  public function assertPanelizerBlock($label, $region) {
    $row = $this->getBlockDiv($label, $region);
    if ($row) {
      return $row;
    }
    else {
      throw new ExpectationException("Expected block '{$label}' to be present in '{$region}' region.", $this->getSession()->getDriver());
    }
  }
  /**
   * Removes a block from the panelizer layout via the Wizard.
   *
   * Assumes that exactly one block with the given name exists in the given
   * region.
   *
   * @param string $label
   *   The label of the block to remove.
   * @param string $region
   *   The machine name of the region in which the block is currently placed.
   *
   * @When I remove the :label block from the :region panelizer region
   */
  public function removePanelizerBlock($label, $region) {
    $blockMenu = $this->minkContext->find('xpath', '//h5[contains(text(), "' . $label . '")]/parent::div');
    $remove = $blockMenu->find('xpath', '//li[@data-action-id="remove"]/a');
    $remove->click();
  }

  /**
   * Returns the div for a specific block in a specific region.
   * I don't love the way I've built this. It works now, but it's based off
   * the title and I think those are not required...
   *
   * @param string $block_label
   *   The label of the block to locate.
   * @param string $region
   *   The machine name of the region in which the block is expected to be.
   *
   * @return \Behat\Mink\Element\NodeElement|null
   *   The row element, or null if one was not found.
   */
  protected function getBlockDiv($block_label, $region) {
    $region = strtolower($region);
    $page = $this->getSession()->getPage();

    $regionCSS = '.block-region-' . $region;
    $divName = "//h2[text()[contains(.,'" . $block_label . "')]]";

    $region = $page->find('css', $regionCSS);
    $div = $region->find('xpath', $divName);
    return $div;
  }

  /**
   * Asserts that a block with a specific plugin ID is present.
   *
   * @param string $plugin_id
   *   The block plugin ID.
   *
   * @Then I should see a :plugin_id block
   */
  public function assertBlock($plugin_id) {
    $this->assertSession()->elementExists('css', 'div[data-block-plugin-id = "' . $plugin_id . '"]');
  }
  /**
   * Asserts that a block with a specific plugin ID is NOT present.
   *
   * @param string $plugin_id
   *   The block plugin ID.
   *
   * @Then I should not see a :plugin_id block
   */
  public function assertNotBlock($plugin_id) {
    $this->assertSession()->elementNotExists('css', 'div[data-block-plugin-id = "' . $plugin_id . '"]');
  }
  /**
   * Asserts that a block has contextual links.
   *
   * @param string $plugin_id
   *   The block plugin ID.
   * @param string $link_class
   *   (optional) The class for a specific contextual link to assert.
   *
   * @Then the :plugin_id block should have contextual links
   * @Then the :plugin_id block should have a :link_class contextual link
   * @Then I should see a :plugin_id block with contextual links
   * @Then I should see a :plugin_id block with a :link_class contextual link
   */
  public function assertBlockContextualLinks($plugin_id, $link_class = NULL) {
    $selector = 'div[data-block-plugin-id = "' . $plugin_id . '"] ul.contextual-links';
    if ($link_class) {
      $selector .= ' li.' . $link_class;
    }
    $this->assertSession()->elementExists('css', $selector);
  }
  /**
   * Customizes a node view mode.
   *
   * @param string $view_mode
   *   The view mode ID.
   * @param string $node_type
   *   The node type ID.
   *
   * @When I customize the :view_mode view mode of the :node_type content type
   *
   * @Given I have customized the :view_mode view mode of the :node_type content type
   */
  public function customizeViewMode($view_mode, $node_type) {
    $this->minkContext->visit('/admin/structure/types/manage/' . $node_type . '/display');
    $this->minkContext->assertCheckBox('display_modes_custom[' . $view_mode . ']');
    $this->minkContext->pressButton('Save');
  }
  /**
   * Uncustomizes a node view mode.
   *
   * @param string $view_mode
   *   The view mode ID.
   * @param string $node_type
   *   The node type ID.
   *
   * @When I uncustomize the :view_mode view mode of the :node_type content type
   *
   * @Given I have uncustomized the :view_mode view mode of the :node_type content type
   */
  public function uncustomizeViewMode($view_mode, $node_type) {
    $this->minkContext->visit('/admin/structure/types/manage/' . $node_type . '/display');
    $this->minkContext->assertUncheckBox('display_modes_custom[' . $view_mode . ']');
    $this->minkContext->pressButton('Save');
  }

  /**
   * Clicks an arbitrary element, found by CSS selector.
   *
   * @param string $selector
   *   The CSS selector.
   *
   * @throws \Behat\Mink\Exception\ElementNotFoundException
   *   If the specified element is not present on the page.
   *
   * @When I click the :selector element
   */
  public function clickElementBySelector($selector) {
    $session = $this->getSession();
    $element = $session->getPage()->find('css', $selector);
    if ($element) {
      try {
        $this->scrollToElement($selector);
      }
      catch (UnsupportedDriverActionException $e) {
        // Don't worry about it.
      }
      $element->click();
    }
    else {
      throw new ElementNotFoundException($session, 'element', 'css', $selector);
    }
  }

  /**
  * @Then I click the Panelizer :arg1 link
  */
 public function iClickThePanelizerLink($arg1)
 {
   $panelizerLink = $this->minkContext->find('xpath', '//a[@title="' . $arg1 . '"]');
   $panelizerLink->click();
 }

 /**
 * Scrolls an element into the viewport.
 *
 * @param string $selector
 *   The element's CSS selector.
 *
 * @When I scroll to the :selector element
 */
public function scrollToElement($selector) {
  $this->getSession()
    ->executeScript('document.querySelector("' . addslashes($selector) . '").scrollIntoView()');
}

}
