# HappySeed

This project rocks and uses MIT-LICENSE. Documentation at the [website](http://seed.happyfuncorp.com/)

## What is it?

HappySeed is a set of application templates to help you get started building out new sites. The main section is a rails application template plus a set of rails generators to help you get started with rails appliations quickly. These generators setup the configuration of the application in a standard way, and the full set of generators include many things for setting up a modern rails app and well as middleman apps. The full set of generators include

* [happy_seed:base](http://seed.happyfuncorp.com/docs/README.00.base.html) environment setup
* [happy_seed:bootstrap](http://seed.happyfuncorp.com/docs/README.01.bootstrap.html)  setting up bootstrap + scaffold templates
* [happy_seed:splash](http://seed.happyfuncorp.com/docs/README.02.splash.html) setting up a splash page
* [happy_seed:devise](http://seed.happyfuncorp.com/docs/README.03.devise.html) setting up devise + customized templates
* [happy_seed:devise_invitable](http://seed.happyfuncorp.com/docs/README.03.devise_invitable.html) setting up devise invitable
* [happy_seed:api](http://seed.happyfuncorp.com/docs/README.01.api.html) Setting up API with rspec_docs and apitome
* [happy_seed:omniauth](http://seed.happyfuncorp.com/docs/README.04.omniauth.html) setting up omni auth
* [happy_seed:twitter](http://seed.happyfuncorp.com/docs/README.05.twitter.html) setting up twitter authentication
* [happy_seed:facebook](http://seed.happyfuncorp.com/docs/README.06.facebook.html) setting up facebook authentication
* [happy_seed:instagram](http://seed.happyfuncorp.com/docs/README.05.instagram.html) setting up instagram authentication
* [happy_seed:googleoauth](http://seed.happyfuncorp.com/docs/README.06.googleoauth.html) setting up oauth with google
* [happy_seed:github](http://seed.happyfuncorp.com/docs/README.06.github.html) setting up oauth with github
* [happy_seed:admin](http://seed.happyfuncorp.com/docs/README.07.admin.html) install active admin
* [happy_seed:angular_install](http://seed.happyfuncorp.com/docs/README.10.angular_install.html) install angular in the app
* [happy_seed:angular_view](http://seed.happyfuncorp.com/docs/README.11.angular_view.html) create a new angular route and template
* [happy_seed:jazz_hands](http://seed.happyfuncorp.com/docs/README.12.jazz_hands.html) jazz_hands for better rails console

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

Clone the repo, and set the `SEED_DEVELOPMENT` environment variable to the local repo directory path. To run the generator from the cloned source, execute:

    $ cd $SEED_DEVELOPMENT
    $ bundle exec bin/happy_seed

This will create an app and set the `happy_seed` gem to use your local `happy_seed` repo. For an existing app, change the Gemfile to have the `happy_seed` gem point to this path. For a new app, this will be set up automatically.

For rails, you can now run the regular generator commands. Since it's inconvenient to create new apps over and over, a simple pattern is, for example:

    $ git commit -a
    $ rails g happy_seed:bootstrap
    $ git reset --hard

