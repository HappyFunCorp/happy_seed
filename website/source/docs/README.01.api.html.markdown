HappySeed API Install
===================

### What does this do?

The `happy_seed:api` generator

* Installs `apitome`
* Installs `rspec_api_documentation`

### Why do you want this?

This allows you to invite users to the site and have them sign up through a link.

### Environment Variables

na

### What needs to be done?

After you update your specs in spec/acceptance, run

```
rake docs:generate
```

to output the files into the docs/api directory.