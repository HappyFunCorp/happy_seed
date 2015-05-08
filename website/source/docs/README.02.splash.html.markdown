HappySeed Splash Install
===================

### What does this do?

The `happy_seed:splash` generator depends upon the `happy_seed:bootstrap` generator and will prompt you to run it if it hasn't already.

* Installs a splash screen with sign up for the mailing list.
* Installs a base styling for the splash screen
* Installs a splash controller which can used to signup for a Mailchimp mailing list.

### Why do you want this?

This is a quick framework to get up a marketing page for your application, and a way to start collecting email addresses.  Everyone wants an interest signup page ASAP.

The splash controller uses a seperate splash layout, which lets you isolate the design of the splash page from the overall content and look and feel of your application.

### Environment Variables

This is for the mailchimp signup form.

```
  MAILCHIMP_API_KEY=
  MAILCHIMP_SPLASH_SIGNUP_LIST_ID=
```

### What needs to be done?

Style the page by editing assets/stylesheets/slash.css.scss, views/splash/index.html.haml, and views/layouts/splash

Sign up for mailchimp, get your api key, create a mailing list and setup the environment.