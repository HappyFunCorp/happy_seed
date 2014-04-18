# Seed

## Usage

A simple rails generator for creating a simple app with a splash page and mailing list signup. To install, just run:

    $ \curl -sSL https://raw.githubusercontent.com/sublimeguile/seed/master/install.sh | bash

The installer copies the seed repo into `~/.seed` and an executable into `/usr/local/bin/seed`. To run the generator, type

    $ seed new your_project_name

and to update,
  
    $ seed update

## What does seed do?

Rails is an opinionated framework when it comes to model-view-controller project structure, but beyond that it certainly doesn't force you to use any specific tools. The goal of seed is to get projects off to a good start by installing and configuring an excellent set of tools. In other words, placeholders are never going to work in IE9, so why should you worry about hunting down all the polyfills and shims every time you start a project? And seriously, who doesn't use devise? Why install that and rewrite the forms every time you start a project?

## I don't like Bootstrap. I'm not using it.

Please give it a chance! Most of this stuff is trivial to remove if you don't like it! Don't like Bootstrap? Do this:

1. Remove `@import 'bootstrap';` from `app/assets/stylesheets/application/index.css.scss`
1. Remove `//= require bootstrap` from `app/assets/javascripts/application.js`
1. Remove `gem 'bootstrap-sass'` from `Gemfile`

There. Totally gone.


### Which tools does this include?

The following is a brief list of the tools included by this generator:

- HTML5 boilerplate, which includes:
  - normalize.css
  - IE polyfills
  - Responsive polyfill
  - Modernizr
  - Google Analytics
- Front-end tools
  - HAML
  - Compass
  - Bootstrap SASS
- Other additions
  - meta-tags gem
  - [rails\_12factor](https://github.com/heroku/rails_12factor) gem
  - unicorn server (with config and Procfile setup)
  - Environment variable setup with `dotenv` gem
  - Comments out Turbolinks code
  - .ruby-version setup
  - Custom scaffolds that are actually useful!
  - Mailchimp integration for signup form


## Environments

Please set up as many accounts as are necessary for all external services. That usually means development, staging, and production accounts.

#### Development

Place all configuration variables in `.env`, as in:

    # .env:
    S3_BUCKET_NAME=development-bucket-name
    AWS_ACCESS_KEY_ID=<development key>
    AWS_SECRET_ACCESS_KEY=<development key>


There should not be any sensitive information in this file, so it is committed to the repo.


#### Staging

If you're using Heroku, all config variables should be set using `heroku config`, as in:

    $ heroku config:add -a your-app-stage S3_BUCKET_NAME=assets.your-app-stage.herokuapp.com


If you're not using Heroku, you should still be using environment variables for <strong>all</strong> config!


#### Production

Same thing. Use environment variables!

    $ heroku config:add -a your-app S3_BUCKET_NAME=assets.your-app.com

## Google Analytics Setup


All you have to do is set the `GOOGLE_ANALYTICS_SITE_ID` environment variable for each environment and you're done! Create the accounts and do it now!


## AWS Setup


Start by setting the keys in the `.env` file if your project uses AWS/S3. Fun fact: If you call your variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, the `aws-sdk` gem finds them and configures itself automatically!


You should ensure that <strong>the client owns their own AWS account</strong>. That means:

1. The client sets up their account if they don't currently have one
1. The client sends you credentials
1. You use AWS Identity and Access Management (IAM) to set up developer accounts and an AWS login page.
1. The client changes their login password, if desired.
1. Set up buckets with restricted access keys for all necessary environments. See the Codex [AWS Setup and Security](http://codex.happyfuncorp.com/slides/11#1) presentation for a walkthrough and links to the relevant resources.

Most importantly, ensure that the project <strong>does not end up on the HFC AWS account</strong>.

## Bootstrap

Bootstrap is really great! The current version is IE8 compatible. That's worth a lot. It's customizable via Sass and all the footwork is done for you! You just have to edit `application/variables.css.scss`.

Here's a summary of the CSS setup:
<dl>

  <dt><code>application/index.css.scss</code>:</dt>
  <dd>The CSS entry point that imports all the other css. Variables are shared among any files imported here.</dd>

  <dt><code>application/variables.css.scss</code></dt>
  <dd>A list of custom Sass varialbes accessible to anything imported by in <code>index.css.scss</code>. This is where you should puts Bootstrap customizations. You can find a full list of Bootstrap variables at: [Customize Bootstrap](http://getbootstrap.com/customize/)

  <dt><code>application/layout.css.scss</code>:</dt>
  <dd>Your custom CSS goes here!</dd>

  <dt><code>application/media_queries.css.scss</code>:</dt>
  <dd>This is where any extra media queries you need should be place. Note that you have access to <a href="http://getbootstrap.com/css/#responsive-utilities">Bootstrap's responsive utilities</a>. Use them!</dd>

</dl>

## HTML5 Boilerplate

HTML5 Boilerplate includes things every project should have like normalize.css, Modernizr, Compass, and a placeholder polyfill for IE. It does some heavy reorganization of your application layout, but it's for the best! Go with it!

&rarr; Read more about

[HTML5 Boilerplate](http://html5boilerplate.com/)



## Ideas? Criticism? Improvements?


If you have bug reports or ideas about how this template can be improved, please suggest them on the [Github issues page](https://github.com/sublimeguile/seed/issues")! Thanks!

