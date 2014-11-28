HappySeed Angular Install
=========================

### What does this do?

The happy_seed angular generator

* Installs angularjs-rails
* Updates application.js to include angular stuff
* Creates a structure in app/assets for templates and angular controllers
* Installs angular_controller.rb, a new angular layout
* Creates a sample landing view

### Why do you want this?

Getting angular to work in rails is a pain, especially when working around the asset pipeline.  Figuring out how to get the controller views to be served correctly is just a hassle, and this gives a model for doing that as well as dealing with forgery.

The philosophy here is that all of the angular html templates are stored out of the assets/templates directory.

### Environment Variables

na

### What needs to be done?

na