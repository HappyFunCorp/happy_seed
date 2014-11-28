HappySeed Bootstrap Install
===========================

### What does this do?

The happy_seed bootstrap generator

* Installs bootstrap-sass
* Installs modernizr-rails
* Organizes the app/assets directory
* Organizes the app/views/layouts and app/views/application directories
* Sets up some application_helper methods to make working with forms easier
* Sets up an application layout with flash notice support, etc.
* Updates the rails scaffolding template to use bootstrap style forms.
* Turns off scaffolding stylesheet generation.

### Why do you want this?

Bootstrap should be the base of all our projects going forward.  This creates a variables.css.scss where you can configure bootstrap to your needs, and you can put the custom css stuff after that.

The splash generator builds on this, but doesn't use the main "application.css" stylesheets or javascripts.  The layout here should be used for the application proper.

Better scaffolding means that it's easier to just whip up things to get started.  While you will obviously eventually rewrite all of this code, it's good to have working stuff to start with that doesn't look painful.

### Environment Variables

```
  GOOGLE_ANALYTICS_SITE_ID=
```

### What needs to be done?

Signup for google analytics and setup the site id.

http://www.google.com/analytics/


