# HappySeed

This project rocks and uses MIT-LICENSE.

## What is it?

HappySeed is an rails application template plus a set of rails generators to help you get started with apps quickly.  These generators setup the configuration of the application in a standard way, and the full set of generators include

* [happy_seed:foreman environment setup](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/foreman/templates/docs/README.00.base.rdoc)
* [happy_seed:bootstrap setting up bootstrap + scaffold templates](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/bootstrap/templates/docs/README.01.bootstrap.rdoc)
* [happy_seed:splash setting up a splash page](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/splash/templates/docs/README.02.splash.rdoc)
* [happy_seed:devise setting up devise + customized templates](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/devise/templates/docs/README.03.devise.rdoc)
* [happy_seed:omniauth setting up omni auth](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/omniauth/templates/docs/README.04.omniauth.rdoc)
* [happy_seed:twitter setting up twitter authentication](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/twitter/templates/docs/README.05.twitter.rdoc)
* [happy_seed:facebook setting up facebook authentication](https://github.com/sublimeguile/happy_seed/blob/master/lib/generators/happy_seed/facebook/templates/docs/README.06.facebook.rdoc)

## Usage

  # gem install happy_seed

  # happy_seed app_name

To list out existing generators:

  # rails g

## Contributing

Clone the repo, and set the SEED_DEVELOPMENT environment variable to the local repo directory.  For an existing app, change the Gemfile to have the happy_seed gem point to this path.  For a new app, this will be setup automatically.