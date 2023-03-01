<?php

use Behat\Behat\Context\Context;
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;
use Behat\MinkExtension\Context\MinkContext;

class LoginOutContext extends MinkContext
{
    /**
     * @Then /^I wait for the suggestion box to appear$/
     */
    public function iWaitForTheSuggestionBoxToAppear()
    {
        $this->getSession()->wait(5000, "$('.suggestions-results').children().length > 0");
    }

        public function __construct()
    {
        $startUrl = 'http://example.com';

  // init Mink and register sessions
  $mink = new Mink(array(
      'goutte1' => new Session(new GoutteDriver(new GoutteClient())),
    //  'goutte2' => new Session(new GoutteDriver(new GoutteClient())),
    //  'custom'  => new Session(new MyCustomDriver($startUrl))
  ));

  // set the default session name
  $mink->setDefaultSessionName('goutte2');

  // visit a page
  $mink->getSession()->visit($startUrl);
      }
}
