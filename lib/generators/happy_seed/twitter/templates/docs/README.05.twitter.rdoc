HappySeed Twitter Install
====================

### What does this do?

The `happy_seed:twitter` depends upon `happy_seed:omniauth` and

* Installs twitter authentication
* Installs links in the nav bar and use signup/signin pages

### Why do you want this?

If you want to have the user connect via twitter, this is the one line command for it.

### Environment Variables

```
  TWITTER_APP_ID=
  TWITTER_APP_SECRET=
```

### What needs to be done?

Go to twitter.com and sign up for an application.  Since you need to set the callbacks as urls, you'll need to create one app for local development and another app for production.  (Possibly one for staging as well.)

Allow the application to sign in with twitter.

https://apps.twitter.com

Also see more: 

http://willschenk.com/scripting-twitter/