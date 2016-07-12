HappySeed Angular View Generator
================================

### What does this do?

The view generator adds

* An entry into angular_app.js.coffee.erb for your controller that asset pipeline savvy
* A base controller in apps/assets/javascripts/controllers
* A base template in app/assets/templates

### Why do you want this?

This sets up your angular views for you in a quick and easy way.

### Environment Variables

na

### What needs to be done?

When you have set up your project and you want to add a new angular view, just run `rails g happy_seed:angular_view <NAME_OF VIEW>`.
