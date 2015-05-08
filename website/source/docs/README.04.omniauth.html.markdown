HappySeed Omniauth Install
=====================

### What does this do?

The `happy_seed:omniauth` generator depends upon `happy_seed:devise` and

* Generates an Intentity model, linked to user
* Installs omniauth
* Installs an omniauth_controller
* Updates devise configuration
* Adds routes
* Removes devise email/password validations, updates database
* Adds FormUser < User model for validations
* Adds a registration controller to allow the user to add email and password for auth strategies that don't support it.

### Why do you want this?

This lets you easily add oauth authentication for 3rd party sites to you application, the main ones being facebook and twitter.  This sets up the infrastructure to make everything work with devise.

The Identity model is used to link up the user with the remote information.  What information is given is stored, though you could go deeper with this.  Additionally, the access token for the user is store in the Identity model for interacting with the remote service on behalf of the user.

It also creates the omniauth_callback controller.  Devise as it's setup out of the box has the user's email address as the login, but not all services will give you the user's email address.  (Twitter for example.)  The controller in this case will check only set the email address if one is returned.

It also creates a registration controller to allow a user to set an email.  If the user hasn't set a password, they can change email without it.  If they set an password, then it is required to change things in the future.

Documented in spec/features/registration_spec.rb


### Environment Variables

Set up a $HOME/.seed_defaults file which contains development application keys.  These will be copied over initially so that you don't need to enter them in all the time.

### What needs to be done?

This is a base module which is used by `happy_seed:twitter`, `happy_seed:facebook` and `happy_seed:instagram`.