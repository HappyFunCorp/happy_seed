# Seed

A simple rails generator for creating a simple app with a splash page and mailing list signup. To start, just run:

    $ \curl -sSL https://raw.githubusercontent.com/sublimeguile/seed/master/install.sh | bash


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
  <dd>This is where any extra media queries you need should be place. Note that you have access to [Bootstrap's media query helpers](#). Use them!</dd>

</dl>

## Other things this template adds

#### HTML5 Boilerplate


HTML5 Boilerplate includes things every project should have like normalize.css, Modernizr, Compass, and a placeholder polyfill for IE. It does some heavy reorganization of your application layout, but it's for the best! Go with it!

&rarr; Read more about

[HTML5 Boilerplate](http://html5boilerplate.com/)



#### This splash page

    /app/views/splash/index.html.haml

## Improvements?


If you have bug reports or ideas about how this template can be improved, please suggest them on the [Github issues page](https://github.com/sublimeguile/seed/issues")! Thanks!

