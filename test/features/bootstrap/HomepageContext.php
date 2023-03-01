<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Drupal\DrupalExtension\Context\RawDrupalContext;
use Drupal\DrupalExtension\Context\DrupalContext;
use Behat\MinkExtension\Context\RawMinkContext;


/**
 * Defines application features from the specific context.
 */
class HomepageContext extends RawDrupalContext implements Context, SnippetAcceptingContext
{
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
     * @Then I should see :arg1 nodes in the :arg2 block
     */
    public function iShouldSeeNodesInTheBlock($arg1, $arg2)
    {
      $blockName = strtolower(str_replace(' ', '_', $arg2));
      if ($arg2 == 'SEC Stories') {
        $nodeSelector = '.homepage_featured_stories-' . $blockName . ' .sec-stories-col';
      }
      else {
        $nodeSelector = '.homepage_featured_content-' . $blockName . ' .views-row';
      }
      $page = $this->getSession()->getPage();
      $count = sizeof($page->findAll('css', $nodeSelector));
      if ($count < $arg1) {
        throw new Exception('Not enough nodes (' . $count . ') in ' . $arg2 . ' block');
      }
      elseif ($count > $arg1) {
        throw new Exception('Too many nodes (' . $count . ') in ' . $arg2 . ' block');
      }
    }

    /**
  * @Then I should see the link :first_link before I see the link :second_link in the :region region
  */
  public function iShouldSeeTheLinkBeforeISeeTheLinkInTheRegion($first_link, $second_link, $region)
      {
        $page = $this->getSession()->getPage();
        $regionObj = $page->find('region', $region);
        $rows=$regionObj->findAll('xpath','//div[contains(concat(" ", @class, " "), "views-row")]');
        $foundFirst = false;
        $foundinOrder = false;
        // Iterate over the rows of the view
        foreach ($rows as $row) {
        if (!empty($row->findLink($first_link))) {
                $foundFirst = true;
                }
            elseif ($foundFirst && !empty($row->findLink($second_link))) {
                  $foundinOrder = true;
                  break;
                   }
                }
                if (!$foundinOrder) {
                  throw new Exception("The link " . $first_link . " was not found before the link " . $second_link);
                  }
          }

          /**
         * @When /^I hover over the element "([^"]*)"$/
         */
        public function iHoverOverTheElement($locator)
        {
                $session = $this->getSession(); // get the mink session
                $element = $session->getPage()->find('css', $locator); // runs the actual query and returns the element

                // errors must not pass silently
                if (null === $element) {
                    throw new \InvalidArgumentException(sprintf('Could not evaluate CSS selector: "%s"', $locator));
                }

                // ok, let's hover it
                $element->mouseOver();
        }
}
