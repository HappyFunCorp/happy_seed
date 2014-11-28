HappySeed Omniauth Install
=====================

### What does this do?

The `happy_seed:omniauth` generator depends upon `happy_seed:devise` and

* Generates an Intentity model, linked to user
* Installs omniauth
* Installs an omniauth_controller
* Updates devise configuration
* Adds routes
* Inserts code into User to do the lookup
* Inserts fallback controller to handle the login

### Why do you want this?

This lets you easily add oauth authentication for 3rd party sites to you application, the main ones being facebook and twitter.  This sets up the infrastructure to make everything work with devise.

The Identity model is used to link up the user with the remote information.  What information is given is stored, though you could go deeper with this.  Additionally, the access token for the user is store in the Identity model for interacting with the remote service on behalf of the user.

It also creates the omniauth_callback controller.  Devise as it's setup out of the box has the user's email address as the login, but not all services will give you the user's email address.  (Twitter for example.)  The controller in this case will check to see if the email address is returned, and if not, it will prompt the user for one.  This may not be the functionality that you desire.


### Environment Variables

na (done in the providers)

### What needs to be done?

This is a base module which is used by `happy_seed:twitter`, `happy_seed:facebook` and `happy_seed:instagram`.