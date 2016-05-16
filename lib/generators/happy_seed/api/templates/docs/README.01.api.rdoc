HappySeed API Install
===================

### What does this do?

The `happy_seed:api` generator

* Installs `apitome`
* Installs `rspec_api_documentation`

### Why do you want this?

1. creates a base api framework for a project that is not exclusively api, and has html as well
2. creates user signup, login and logout endpoints
3. creates integration tests for these endpoints
4. generates documentation at docs/api for these endpoints

### Environment Variables

na

### What needs to be done?

After you update your specs in spec/acceptance, run

```
rake docs:generate
```

to output the files into the docs/api directory.