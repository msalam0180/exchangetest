<?php

if (file_exists('/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/saml_admin.php')) {
  require_once('/var/www/html/' . $_ENV['AH_SITE_NAME'] . '/acquia-files/nobackup/simplesaml/saml_admin.php');
}

/**
 * @file
 * SimpleSamlPhp Acquia Configuration.
 *
 * This file was last modified on in July 2018.
 *
 * All custom changes below. Modify as needed.
 */

/**
 * Defines Acquia account specific options in $config keys.
 *
 *   - 'store.sql.name': Defines the Acquia Cloud database name which
 *     will store SAML session information.
 *   - 'store.type: Define the session storage service to use in each
 *     Acquia environment ("defualts to sql").
 */

// Set some security and other configs that are set above, however we
// overwrite them here to keep all changes in one area.
$config['technicalcontact_name'] = "Administrator";
$config['technicalcontact_email'] = "drupalsupport@sec.gov";

// Change these for your installation.
$config['secretsalt'] = 'atpaructxv4khfsaytobthrwj23mnn5z';
$config['auth.adminpassword'] = (string) getenv('SAML_ADMIN');

$config['admin.protectindexpage'] = TRUE;
$config['admin.protectmetadata'] = TRUE;

/**
 * Support SSL Redirects to SAML login pages.
 *
 * Uncomment the code following code block to set
 * server port to 443 on HTTPS environment.
 *
 * This is a requirement in SimpleSAML when providing a redirect path.
 *
 * @link https://github.com/simplesamlphp/simplesamlphp/issues/450
 *
 */
// Prevent Varnish from interfering with SimpleSAMLphp.
// SSL terminated at the ELB / balancer so we correctly set the SERVER_PORT
// and HTTPS for SimpleSAMLphp baseurl configuration.
$protocol = 'http://';
$port = ':80';
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
  $_SERVER['SERVER_PORT'] = 443;
  $_SERVER['HTTPS'] = 'true';
  $protocol = 'https://';
  $port = ':' . $_SERVER['SERVER_PORT'];
}
$config['baseurlpath'] = $protocol . $port . '/simplesaml/';

// Default database name to Exchange.
$db_name = 'insidergov';

$ah_options = [
  // Use the database "role" without the "stage", e.g., "example", not
  // "exampletest" or "exampleprod".
  // Change the following line to match your database name.
  'database_name' => $db_name,

  'session_store' => [
    // Valid values are "memcache" and "database", database is recommended.
    // Note that the below config will be for only the dev, test, and prod
    // environments. If you would like to cover additional environments, list
    // them here.
    'prod' => 'database',
    'stg' => 'database',
    'dev'  => 'database',
    'dev1'  => 'database',
    'test0'  => 'database',
    'test1'  => 'database',
    'train'  => 'database',
  ],
];

/**
 * Cookies No Cache.
 *
 * Allow users to be automatically logged in if they signed in via the same
 * SAML provider on another site by uncommenting the setcookie line below.
 *
 * Warning: This has performance implications for anonymous users.
 *
 * @link https://docs.acquia.com/resource/simplesaml/
 */
// Commenting out NO_CACHE cookie to prevent Varnish caching bypass.
// setcookie('NO_CACHE', '1', 0, '', '', TRUE, TRUE);

/**
 * Generate Acquia session storage via hosting creds.json.
 *
 * Session storage defaults using the database for the current request.
 *
 * @link https://docs.acquia.com/resource/using-simplesamlphp-acquia-cloud-site/#storing-session-information-using-the-acquia-cloud-sql-database
 */

if (!getenv('AH_SITE_ENVIRONMENT')) {
  // Add / modify your local configuration here.
  $config['store.type'] = 'sql';
  $config['store.sql.dsn'] = sprintf('mysql:host=%s;port=%s;dbname=%s', '127.0.0.1', '', 'drupal');
  $config['store.sql.username'] = 'drupal';
  $config['store.sql.password'] = 'drupal';
  $config['store.sql.prefix'] = 'simplesaml';
  $config['certdir'] = "/var/www/{$_ENV['AH_SITE_GROUP']}.{$_ENV['AH_SITE_ENVIRONMENT']}/acquia-files/nobackup/simplesaml/cert/";
  $config['metadatadir'] = "/var/www/{$_ENV['AH_SITE_GROUP']}.{$_ENV['AH_SITE_ENVIRONMENT']}/simplesaml/metadata";
  $config['baseurlpath'] = 'simplesaml/';
  $config['loggingdir'] = '/var/www/simplesamlphp/log/';

  // Enable as IdP for local Idp domains.
  if (in_array($_SERVER['SERVER_NAME'], ['local.example.com', 'employee.example.com'])) {
    $config['enable.saml20-idp'] = TRUE;
  }
}
elseif (getenv('AH_SITE_ENVIRONMENT')) {
  // Set ACE and ACSF sites based on hosting database and site name.
  $config['certdir'] = "/mnt/www/html/{$_ENV['AH_SITE_GROUP']}.{$_ENV['AH_SITE_ENVIRONMENT']}/acquia-files/nobackup/simplesaml/cert/";
  $config['metadatadir'] = "/mnt/www/html/{$_ENV['AH_SITE_GROUP']}.{$_ENV['AH_SITE_ENVIRONMENT']}/simplesaml/metadata";
  // Base url path already set above.
   $config['baseurlpath'] = 'simplesaml/';
  // Setup basic logging.
  $config['logging.handler'] = 'file';
  $config['loggingdir'] = dirname(getenv('ACQUIA_HOSTING_DRUPAL_LOG'));
  $config['logging.logfile'] = 'simplesamlphp-' . date('Ymd') . '.log';
  $creds_json = file_get_contents('/var/www/site-php/' . $_ENV['AH_SITE_GROUP'] . '.' . $_ENV['AH_SITE_ENVIRONMENT'] . '/creds.json');
  $databases = json_decode($creds_json, TRUE);
  $creds = $databases['databases'][$db_name];
  if (substr($_ENV['AH_SITE_ENVIRONMENT'], 0, 3) === 'ode') {
    $creds['host'] = key($creds['db_url_ha']);
  }
  else {
    require_once "/usr/share/php/Net/DNS2_wrapper.php";
    try {
      $resolver = new Net_DNS2_Resolver([
        'nameservers' => [
          '127.0.0.1',
          'dns-master',
        ],
      ]);
      $response = $resolver->query("cluster-{$creds['db_cluster_id']}.mysql", 'CNAME');
      $creds['host'] = $response->answer[0]->cname;
    }
    catch (Net_DNS2_Exception $e) {
      $creds['host'] = "";
    }
  }
  $config['store.type'] = 'sql';
  $config['store.sql.dsn'] = sprintf('mysql:host=%s;port=%s;dbname=%s', $creds['host'], $creds['port'], $creds['name']);
  $config['store.sql.username'] = $creds['user'];
  $config['store.sql.password'] = $creds['pass'];
  $config['store.sql.prefix'] = 'simplesaml';
}
