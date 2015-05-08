HappySeed Github Install
====================

### What does this do?

The `happy_seed:github` depends upon `happy_seed:omniauth` and

* Installs github authentication
* Installs github api gem

### Why do you want this?

If you want to have the user connect via github, this is the one line command for it.

### Environment Variables

```
  GITHUB_APP_ID=
  GITHUB_APP_SECRET=
```

### What needs to be done?

In config/initializers/devise.rb make sure that the scope you are requesting is correct.

Since you need to set the callbacks as urls, you'll need to create one app for local development and another app for production.  (Possibly one for staging as well.)

https://github.com/settings/applications