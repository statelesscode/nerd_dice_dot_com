[![Coverage Status](https://coveralls.io/repos/github/statelesscode/nerd_dice_dot_com/badge.svg?branch=main)](https://coveralls.io/github/statelesscode/nerd_dice_dot_com?branch=main)
![Build](https://github.com/statelesscode/nerd_dice_dot_com/actions/workflows/main.yml/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/d4760835b493d2cf500e/maintainability)](https://codeclimate.com/github/statelesscode/nerd_dice_dot_com/maintainability)

# NerdDice.com Ruby on Rails Application
NerdDice.com is a Ruby on Rails (currently version `7.0.x`\) web application for managing table top role-playing games. There are quite a bit of potential features that we could incorporate to add value to players and game masters. Features will be prioritized and added incrementally using an agile methodology of trying to maximize early value delivery. We're still in the early stages of application development, but you can check out our [project backlog](https://github.com/orgs/statelesscode/projects/1) and [issues list](https://github.com/statelesscode/nerd_dice_dot_com/issues) for the latest information.

## Educational Videos By Stateless Code
We encourage you to [code along](#code-along). The end-to-end process of developing this application is being captured as [instructional videos](https://youtube.com/playlist?list=PL9kkbu1kLUeMJFb0GT8ZMzrsSKJaxjOKH). The videos are in a one-take style so that the mistakes along the way have troubleshooting and the concepts used to develop the application are explained as they are covered. We try to keep the videos targeted to a single topic, user story, or sub-task to the extent possible. This is primarily an educational project with the goal of providing a true end-to-end of the entire life cycle of development of a Ruby on Rails application. We have other video series as well. Check them out at our [YouTube channel](https://www.youtube.com/statelesscode) or by visiting our [website](https://statelesscode.com).

When appropriate, we also add groups of videos for a related topic to their own playlists in addition to the main  [NerdDice.com playlist](https://youtube.com/playlist?list=PL9kkbu1kLUeMJFb0GT8ZMzrsSKJaxjOKH). Current sub-playlists are below:
- [Using Devise 4.8 on Ruby on Rails 7 with Turbo and Tailwind](https://youtube.com/playlist?list=PL9kkbu1kLUeMnvkrX7EOLSv6glmQzGMXL)

## Application Setup and Configuration
To get the application up and running in your local development environment, take note of the following particulars of the application.

- [Install needed Ruby version](#ruby-version) including [bundler](#bundler)
- [Install PostgreSQL](#postgres)
- Clone or [fork](https://github.com/statelesscode/nerd_dice_dot_com/fork) \(then clone\) this GitHub repository
- Run `bundle install` from the root directory of the application
- [Configure the application secrets](#secrets-config)
- [Set up the database](#database-setup)
- [Run the test suite](#running-tests)
- [Run the development server](#dev-server)
<a name="ruby-version"></a>
### Ruby Version
The application runs on Ruby version specified in the [.ruby-version](.ruby-version) file of the root directory of the application. Which Ruby version management option you choose shouldn\'t make an impact on the setup of the application. Note that Ruby [3.2.0](https://www.ruby-lang.org/en/news/2022/12/25/ruby-3-2-0-released/) and later no longer bundles Stdlib 3rd party sources like `libyaml` and `libffi`. We do have a video on how to [Install RVM and Ruby](https://youtu.be/h-JBRJH8W7A) on Ubuntu `20.04` with Ruby versions `2.7` and `3.0`. Other than the noted differences with `libyaml` and `libffi` the process should essentially be the same on Debian variants of Linux. The dependencies needed to install Ruby may vary from system to system.
<a name="bundler"></a>
After you install Ruby and Bundler, you should get version outputs when you execute `ruby -v` and `bundle --version` in your command line.

### System Dependencies
In order to run this in a development environment, you need to have these other system dependencies installed. This application uses the Rails 7 default of [Importmap for Rails](https://github.com/rails/importmap-rails), so you don't need `npm`, `yarn` \(or technically even `node`\) to install and run the application.

<a name="postgres"></a>
#### PostgreSQL
In order for the app to run, you need to have PostgreSQL installed on your system. We have a setup video where we [Install PostgreSQL 13 and its additional packages](https://www.youtube.com/watch?v=mW3vAvUg2Ao&list=PL9kkbu1kLUeNWCKuMbpzE8r1xkx8L1Xf0&index=5&t=232s). You should be able to run the application without modifying the `config/database.yml` file. See the instruction comments [in that file](config/database.yml) for platform-specific tips.

<a name="system-test-browser"></a>
#### A browser that can run your system tests
By default, the [system tests](test/system) run on `headless_chrome`. If you wish to run the system tests without any environment variable overrides, you need to install headless Chrome on your system. Otherwise you can use any other supported browser test driver and specify the `BROWSER_TEST_DRIVER` environment variable when running system tests.

<a name="secrets-config"></a>
### Secrets Configuration
The application uses environment-specific secrets. In order to run the development and test versions of the app, you will need to setup secrets for `development` and `test`. You would remove the `development.yml.enc` and `test.yml.enc` files from the [config/credentials](config/credentials) directory on your own application. \(**DO NOT INCLUDE CHANGES TO THESE FILES WHEN SUBMITTING PULL REQUESTS.**\) The environment secrets files need to have the following attributes present:
```yml
#   app secret key base run `bin/rails secret` to generate
secret_key_base: PASTE_FIRST_RAILS_SECRET_HERE

# devise secrets
devise:
  # Devise uses a separate secret_key and pepper. Run `bin/rails secret` to generate each one
  secret_key: PASTE_SECOND_RAILS_SECRET_HERE
  pepper: PASTE__THIRD_RAILS_SECRET_HERE
```
After deleting the repository version of `development.yml.enc` and `test.yml.enc`, use `rails credentials:edit --environment=ENVIRONMENT_TO_EDIT` \(replacing with the intended environment\). If you plan on interacting with GitHub frequently, you will want to copy and paste your version of the secrets files **and their keys** to a separate directory on your computer or a local git branch. Then you can paste them into your local repo as needed without having to go through the secrets adaptation process each time you pull down the repo.

<a name="database-setup"></a>
### Database Setup
In order to get the database set up \(after you have [installed PostgreSQL](#postgres) and successfully ran `bundle install`, you would run these commands from the root directory of the application.
```bash
bin/rails db:create
bin/rails db:migrate
```
You can isolate to a single environment by using the `RAILS_ENV` environment variable \(ex: `RAILS_ENV=development bin/rails db:create`\). If you need to reset your test database, you can execute `bin/rails db:test:setup`.

<a name="running-tests"></a>
### Running the Test Suite
The test suite is separated into normal rails tests \(run by executing `bin/rails test`\) and browser-driven application system tests  \(run by executing `bin/rails test:system`\). You can run the whole suite together in a single command by executing `bin/rails test:system test`. By default the system tests run with a browser test driver of `headless_chrome`. If you want to run with a different test driver \(often useful to troubleshoot or debug\) you can override this by specifying a different test driver with the `BROWSER_TEST_DRIVER` environment variable.
```bash
# would run with Chrome instead of headless Chrome for this test run
BROWSER_TEST_DRIVER=chrome bin/rails test:system
```
If you want to permanently override your local system test runner, you can set the `BROWSER_TEST_DRIVER` environment variable at the system level.

<a name="dev-server"></a>
### Running the Devopment Server
From the application root directory run `bin/dev` to start the development server and press your operating system's halt command \(usually `CTRL+C`\) to stop the server. By default, this starts the Rails server on `localhost:3000`. Because the application uses [Tailwind CSS](https://github.com/rails/tailwindcss-rails) for styling, you should use `bin/dev` instead of `bin/rails server` to run the development server.

<a name="services"></a>
### Services (job queues, cache servers, search engines, etc.)
TBD. The only service currently needed is the [development server](#dev-server).

<a name="deployment-instructions"></a>
### Deployment Instructions
TBD

<a name="code-along"></a>
## Code Along!
You can contribute to this project in a variety of ways. See the [CONTRIBUTING](CONTRIBUTING.md) page for more details. You don't need to be a programmer to contribute. We welcome [feature requests](CONTRIBUTING.md#feature-requests),  [bug reports](CONTRIBUTING.md#bug-reports),  [code contributions](CONTRIBUTING.md#code-contributions), and [documentation contributions](CONTRIBUTING.md#documentation-contributions) as well as [art, design and/or creative input](CONTRIBUTING.md#art-design-creative-input).

<a name="conduct"></a>
## Conduct
Just be polite and courteous in your interactions. It is possible to disagree passionately about ideas without making it personal. You can make a point without using language that leads to escalation. Nobody working on this project is perfect. In the event that something goes wrong, seek forgiveness and reconciliation with one another. **[Mercy triumphs over judgment](https://www.biblegateway.com/passage/?search=James+2&version=ESV)**.

We welcome and encourage your participation in this open-source project. We welcome those of all backgrounds and abilities, but we refuse to adopt the Contributor Covenant or any similar code of conduct for reasons outlined in [BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE](BURN_THE_CONTRIBUTOR_COVENANT_WITH_FIRE.md). We welcome those who disagree about codes of conduct to contribute to this project, but we want to make it abundantly clear that Code of Conduct Trolls have no power here.

<a name="legal"></a>
## Legal
So-called \"intellectual property\" is a [racket](https://c4sif.org/aip/). The goal of this legal section is to disavow any claim to intellectual property in the strongest possible terms. The code is made available under the [UNLICENSE](UNLICENSE.txt) and all copyright is vacated under the [Creative Commons](https://creativecommons.org) [CC0 Public Domain Dedication](https://creativecommons.org/publicdomain/zero/1.0/). Copying is not stealing. In the event that the UNLICENSE or CC0 are not enforceable in your jurisdiction substitute it with the most permissive copyright and licensing options available to you in your jurisdiction.
