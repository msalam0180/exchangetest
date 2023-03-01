Test Instructions
=================

**Overview**

This document provides step by step instructions on how to install composer and run behat tests. This document does not cover how to write tests but how to run the tests.
**Requirements**

Composer and PHP 5.6 is required to run the tests.

Download and run [Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe) - it will install the latest composer version whenever it is executed. 
PHP 5.6 should be installed with DevDesktop. Please note the path to the PHP executable which is usually C:\Program Files (x86)\DevDesktop\php5_6 
You will need that path when installing Composer.

**Running “composer install”**

If installation went flawlessly then you should be able to 
1.	Open a new Windows Command Processor or Git Bash window and navigate to your ~/Sites/devdesktop/secgov-dev/test folder. 
Note: Using the terminal window that is opened by clicking on the “Open Drush Console” button in Acquia DevDesktop will not work unless you fully qualify the path to composer.phar which should be C:\ProgramData\ComposerSetup\bin\composer.phar
2.	Type composer install to install all of the requirements for the project.


**Configuring your Environment for the Tests**

First you need to set an environmental variable named BEHAT_PARAMS with this value, modified with the path to your docroot. After setting this value, please reopen any terminal windows to take effect.

    {"extensions":{"Drupal\\DrupalExtension":{"drupal":{"drupal_root":"C:\\Users\\fabio.rodriguez\\Sites\\devdesktop\\secgov-dev\\docroot"}}}}

Next, open the file named `cld_prod_secgov_dev_default.inc` which is found in your Home directory `~/.acquia/DevDesktop/DrupalSettings`folder 

Copy the definition of the default database into your `sites/default/settings.local.php` file. This should be similar to:

    $databases['default']['default'] = array(
        'driver' => 'mysql',
        'database' => 'secgov_dev',
        'username' => 'drupaluser',
        'password' => '',
        'host' => '127.0.0.1',
        'port' => 33067 );

**Running the Tests**

After composer has finished installing requirements and you have configured your settings.local.php you should be able to run the tests using the following commands, depending on your terminal window

Git Bash: `bin/behat`
Windows Command Processor: `bin\behat`

The console window will run the tests and report.

 