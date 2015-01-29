# HappySeed

This project rocks and uses MIT-LICENSE. Documentation at the [website](http://seed.happyfuncorp.com/)

## What is it?

HappySeed is a set of application templates to help you get started building out new sites. The main section is a rails application template plus a set of rails generators to help you get started with rails appliations quickly. These generators setup the configuration of the application in a standard way, and the full set of generators include many things for setting up a modern rails app and well as middleman apps. The full set of generators include

* [happy_seed:foreman](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/foreman/templates/docs/README.00.base.rdoc) environment setup
* [happy_seed:bootstrap](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/bootstrap/templates/docs/README.01.bootstrap.rdoc)  setting up bootstrap + scaffold templates
* [happy_seed:splash](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/splash/templates/docs/README.02.splash.rdoc) setting up a splash page
* [happy_seed:devise](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/devise/templates/docs/README.03.devise.rdoc) setting up devise + customized templates
* [happy_seed:omniauth](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/omniauth/templates/docs/README.04.omniauth.rdoc) setting up omni auth
* [happy_seed:twitter](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/twitter/templates/docs/README.05.twitter.rdoc) setting up twitter authentication
* [happy_seed:facebook](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/facebook/templates/docs/README.06.facebook.rdoc) setting up facebook authentication
* [happy_seed:instagram](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/instgram/templates/docs/README.05.instagram.rdoc) setting up instagram authentication
* [happy_seed:admin](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/admin/templates/docs/README.07.admin.rdoc) install active admin
* [happy_seed:angular_install](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/angular_install/templates/docs/README.10.angular_install.rdoc) install angular in the app
* [happy_seed:angular_view](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/angular_install/templates/docs/README.11.angular_view.rdoc) create a new angular route and template
* [happy_seed:jazz_hands](https://github.com/happyfuncode/happy_seed/blob/master/lib/generators/happy_seed/jazz_hands/templates/docs/README.12.jazz_hands.rdoc) jazz_hands for better rails console

All of these documents are droped into the docs folder of your project, and can be viewed with the [setup inspector](http://localhost:3000) once you start up the app.

## Usage

    $ gem install happy_seed

    $ happy_seed rails app_name

To list out existing generators:

    $ rails g

## What is this for?

The purpose of this app is to make it quick and easy to start projects by getting all of the basic plumbing out of the way. There are a lot of great gems and tools around to help build software, and for common tasks, this takes away the pain of having to remember how to set them up. The omniauth-twitter gem is great, but remembering exactly how to configure twitter for each new project is a) the same each time and b) a pain to remember. This makes that go away.

This application template and set of generators dumps some sensible configuration into a new rails project and then lets you customize and change from there. It is not necessary to keep it in the project after a certain stage where everything will be custom anyway.

Lets whip up some things quickly!

## Contributing

Clone the repo, and set the `SEED_DEVELOPMENT` environment variable to the local repo directory. To run the generator from the cloned source, execute:

    $ bundle exec bin/happy_seed

For an existing app, change the Gemfile to have the `happy_seed` gem point to this path. For a new app, this will be set up automatically.
