<?php

include_once __DIR__ . '/../../vendor/autoload.php';

use Behat\MinkExtension\Context\RawMinkContext;
use Behat\Behat\Context\Context;

class AnalyticsContext extends RawMinkContext implements Context {

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct($credPath, $view)
  {
    putenv('GOOGLE_APPLICATION_CREDENTIALS=' . $credPath);

    $client = new Google_Client();
    $client->useApplicationDefaultCredentials();
    $client->setScopes(array('https://www.googleapis.com/auth/analytics.readonly'));
    $this->service = new Google_Service_Analytics($client);
    $this->view = $view;
  }

  /**
  * All this does is query against the realtime API and then loop through current user
  * paths. If a path is registered that the test is run against the assertion passes
  * Obviously this might result in false positives (although no more than if a user did the same thing)
  *
  * //TODO:
  * A better test would be to generate a random "campaign" and then inject that into any view
  * then check that the path with that injected campaign exists.
  * @Then /^Google Analytics tracks a pageview on "([^"]*)"$/
  */
  public function googleAnalyticsTracksAPageviewOn($arg1)
  {
    $try = 1;

    while ($try < 15) {
      $query = $this->queryGoogleAnalytics('rt:pagePath');
      if(is_array($query->getRows()) === TRUE) {
        foreach ($query->getRows() as $row) {
          if ($row[0] == $arg1) {
            return;
          }
        }
      }
      $try++;
      sleep(5);
    }
    throw new \Exception('Pageview not tracked');
  }

  /**
   * @param string $dimensions
   * @param string $filters
   * @return \Google_Service_Analytics_RealtimeData
   */
  function queryGoogleAnalytics($dimensions = '') {
    $queryOptions = array(
      'dimensions' => $dimensions
    );

    return $this->service->data_realtime->get('ga:' . $this->view, 'rt:activeUsers', $queryOptions);
  }

}
