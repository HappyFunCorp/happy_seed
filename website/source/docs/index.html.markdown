---
title: Hi there
---

## What is it?

HappySeed is a set of application templates to help you get started building out new sites.  The main section is a rails application template plus a set of rails generators to help you get started with rails appliations quickly.  These generators setup the configuration of the application in a standard way, and the full set of generators include many things for setting up a modern rails app and well as middleman apps.

## Overall pattern

Once HappySeed generates files for you, there is no runtime dependancy.  In the case of rails generators, these make changes to your source directory that you then own completely.  There is no need to deploy the `happy_seed` gem in a production environment.

The problem we are trying to solve here is _how to get started quickly_.  As time goes on, your needs are going to diverge from anything we could imagine or anticipate, so we aren't even going to try.  We'll just give you the base line.

## Installation

```sh
$ gem install happy_seed
```

There are a few different ways to use this.

`happy_seed rails app_name` -- [read rails documentation](/docs/rails.html)

`happy_seed plugin plugin_name` -- [read plug in documentation](/docs/plugin.html)

`happy_seed engine engine_name` -- [read engine documentation](/docs/plugin.html)

`happy_seed static static_site` -- [read static documentation](/docs/middleman.html)