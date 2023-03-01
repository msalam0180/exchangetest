# Project Details

This project is a Drupal 9 SEC's internal site Exchange.

- Exchange - [https://theexchange.sec.gov](https://theexchange.sec.gov)

## Technology Stack
<a href="https://www.acquia.com/"><img height="45" src="https://www.acquia.com/themes/custom/juice/logo.svg"></a>

<a href="https://www.drupal.org/"><img height="55" src="https://www.drupal.org/files/Wordmark_blue_RGB.png"></a>


| Service    | Link                                                                         |
| ---------- | ---------------------------------------------------------------------------- |
| Acquia URL | https://cloud.acquia.com/a/applications/4f37a5d5-b679-4b04-83cb-cf97797d574d |
| GitLab     | https://jira.jiratracker.com/sec/insider/                                    |
## Getting Started

1. Request access to [GitLab](https://jira.jiratracker.com/sec/insider/) and [Acquia Cloud](https://cloud.acquia.com/a/applications/c934299e-58d4-4c50-8da4-246726de9622).
2. Ensure that your computer meets the minimum installation requirements for [Lando v3.0.26](https://docs.lando.dev/basics/installation.html#system-requirements) and [Docker 2.5.0.1](https://docs.lando.dev/basics/installation.html#docker-engine-requirements).
3. Install [Docker 2.5.0.1](https://docs.docker.com/docker-for-windows/release-notes/#docker-desktop-community-2501)
4. Install [Lando v3.0.26](https://github.com/lando/lando/releases/tag/v3.0.26)
5. Setup a SSH key that can be used for GitLab and the Acquia Cloud (Use same SSH key for both accounts).
    1. [Setup GitLab SSH Keys](https://docs.gitlab.com/ee/ssh/#generate-an-ssh-key-pair)
    2. [Setup Acquia Cloud SSH Keys](https://docs.acquia.com/cloud-platform/manage/ssh/enable/add-key/)
6. Install necessary tools listed below:
    1. Command line tools:
        1. [GitBash](https://git-scm.com/downloads) - Required
        2. [cmder](https://cmder.net/) for better command-line support - Optional
        3. [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) - Optional
    2. Code Editors:
        1. [VSCode](https://code.visualstudio.com/download) - Required
        2. [Notepad++](https://notepad-plus-plus.org/download) - Required
        3. [PhpStorm](https://www.jetbrains.com/phpstorm/) - Optional

## Configure Git
1. Start a command line tool to configure Git.
2. Set username and email (Change **email** and **name** value to your work email and name).
    ```
    $ git config --global user.name "Your Name"
    $ git config --global user.email "youremail@yourdomain.com"
    ```
2. Set default Linux (LF) line ending instead of Windows (CRLF).
    ```
    $ git config --global core.autolf true
    $ git config --global core.autocrlf false
    ```
3. Allow Git to have longpath.
    ```
    $ git config --global core.longpaths true
    ```
## Setup Local Environment
1. Clone repository using a command line tool. By default, Git names this "origin" on your local.
    ```
    $ git clone git@jira.jiratracker.com:sec/insider.git ~/sites/exchange/
    ```
2. Change directory to exchange project
    ```
    $ cd ~/sites/exchange/
    ```
3. Start local LAMP stack with Lando (Docker will start automatically if not, run Docker manually)
    ```
    $ lando start
    ```
4. Login to Acquia CLI (acli) *Note:* Only required if you are building lando project from scratch or after `$ lando destroy`.
    ```
    $ lando acli auth:login
    ```

    Follow the prompts to complete setting up Acquia CLI.
    > - Would you like to share anonymous performance usage and data? (yes/no) - **[No]**
    > - Do you want to open this page to generate a token now? (yes/no) - **[No]**
    > - Please enter your API Key: - **[Generate this from Acquia: [https://cloud.acquia.com/a/profile/tokens](https://cloud.acquia.com/a/profile/tokens)]**
    > - Please enter your API Secret (input will be hidden): - **[Generate this from Acquia: [https://cloud.acquia.com/a/profile/tokens](https://cloud.acquia.com/a/profile/tokens)]**
5. Pull database locally.
    ```
    $ lando pulldb
    ```
6. Run database import command to import database locally.
    | Site     | Command                                          |
    | -------- | ------------------------------------------------ |
    | Exchange | `$ lando db-import exchangedb.sql -h exchangedb` |

7. Initialize a project.
    | Site     | Command                        |
    | -------- | ------------------------------ |
    | Exchange | `$ lando initproject-exchange` |

## Setup Microsite
1. Start a command line tool and change directory to exchange project.
    ```
    $ cd ~/sites/exchange/
    ```
2. Initialize Microsites (gatsby).
    ```
    $ lando initgatsby
    ```
3. Within microsites directory create .env.local file based on .env.example file. (Set environment values after creating .env.local file).

   *Note:* This should be one time setup unless you delete microsites directory.
    ```
    $ cp microsites/.env.example microsites/.env.local
    ```
4. Run Microsites command.
    ```
    $ lando gatsby-run
    ```

## Setup Behat Testing Environment
1. Install [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)
2. Open VNC Viewer and connect to localhost:5901
3. Start a command line tool and change directory to exchange project.
    ```
    $ cd ~/sites/exchange/
    ```
4. Initialize Behat.
    ```
    $ lando initbehat
    ```
5. Run Behat command.
    | Site      | Command                   |
    | --------- | ------------------------- |
    | Exchange  | `$ lando behat-exchange`  |
    | Microsite | `$ lando behat-microsite` |

## Useful commands

Below is a list of useful command for local lando setup. Use `$ lando --help` command to display additional commands.

| Command                        | Explanation                                                                                                                                                                |
| --------------------------     | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `$ lando acli`                 | Acquia CLI is a command-line interface for interacting with Cloud Platform services. <br/>***\*\*\*WARNING***\*\*\* this command interacts with Acquia Cloud Environments. |
| `$ lando acli-drush`           | Runs drush command on Acquia Cloud given site and environment. <br/>***\*\*\*WARNING***\*\*\* this command interacts with Acquia Cloud Environments.                       |
| `$ lando behat`                | Runs Behat command without any Behat Parameters.                                                                                                                           |
| `$ lando behat-exchange`       | Runs Behat command for local exchange site.                                                                                                                                |
| `$ lando behat-microsite`      | Runs Behat command for local microsite site.                                                                                                                                |
| `$ lando composer`             | Runs composer commands                                                                                                                                                     |
| `$ lando drush`                | Allows you to run drush locally. [Usage - lando drush cr]                                                                                                                  |
| `$ lando gatsby-run`           | Run commands to start gatsby run.                                                                                                                                          |
| `$ lando gulp`                 | Runs gulp commands                                                                                                                                                         |
| `$ lando info`                 | Prints info about your app                                                                                                                                                 |
| `$ lando initbehat`            | Runs npm install and composer install for Behat and WDIO.                                                                                                                  |
| `$ lando initgatsby`           | Runs npm install for gatsby.                                                                                                                                               |
| `$ lando initproject-exchange` | Runs cr, updb, cim, user-create (lando) with admin permissions on local exchange site.                                                                                     |
| `$ lando login-investor`       | Creates one-time login link as admin for local investor site.                                                                                                              |
| `$ lando login-exchange`       | Creates one-time login link as admin for local exchange site.                                                                                                              |
| `$ lando node`                 | Runs node commands                                                                                                                                                         |
| `$ lando npm`                  | Runs npm commands                                                                                                                                                          |
| `$ lando php`                  | Runs php commands                                                                                                                                                          |
| `$ lando pulldb`               | Pulls database down locally.                                                                                                                                               |
| `$ lando rebuild`              | Rebuilds your app from scratch, preserving data                                                                                                                            |
| `$ lando restart`              | Restarts your app                                                                                                                                                          |
| `$ lando ssh`                  | Drops into a shell on a service, runs commands                                                                                                                             |
| `$ lando start`                | Starts your app                                                                                                                                                            |
| `$ lando stop`                 | Stops your app                                                                                                                                                             |
| `$ lando theme-exchange-build` | Runs npm install and compiles exchange theme sass.                                                                                                                         |
| `$ lando xdebug-off`           | Disable xdebug for Apache.                                                                                                                                                 |
| `$ lando xdebug-on`            | Enable xdebug for Apache.                                                                                                                                                  |
