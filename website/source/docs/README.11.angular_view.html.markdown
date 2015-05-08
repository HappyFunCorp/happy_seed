HappySeed Angular View Generator
================================

### What does this do?

The view generator adds

* An entry into angular_app.js.coffee.erb for your controller that asset pipeline savvy
* A base controller in apps/assets/javascripts/controllers
* A base template in app/assets/templates

### Why do you want this?

Getting angular to work in rails is a pain, especially when working around the asset pipeline.  Figuring out how to get the controller views to be served correctly is just a hassle, and this gives a model for doing that as well as dealing with forgery.

The philosophy here is that all of the angular html templates are stored out of the assets/templates directory.

### Environment Variables

na

### What needs to be done?

na