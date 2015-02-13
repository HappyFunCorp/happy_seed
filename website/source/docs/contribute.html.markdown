## Contributing to Seed

To contribute to Seed, clone the [happy\_seed repo](https://github.com/happyfuncode/happy_seed). To create a new app with the the rails generator script, run


```
$ export SEED_DEVELOPMENT=/path/to/your/happy_seed
$ cd /path/to/your/happy_seed
$ bundle exec happy_seed rails mytestapp
```

This will generate, for example, a new rails app and will set the `happy_seed` gem to use the source specified in `SEED_DEVELOPMENT`. Within that app, you can then use the regular generator commands, for example:

```
$ cd mytestapp
$ rails generate happy_seed:bootstrap
```

Since it's inconvenient to generate apps over and over, a simple pattern to test and undo your changes is

```
$ git commit -a
$ rails generate happy_seed:bootstrap
$ git reset --hard
```

Write tests where needed and submit a pull request!
