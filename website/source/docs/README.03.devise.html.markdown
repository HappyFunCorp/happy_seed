HappySeed Devise Install
===================

### What does this do?

The happy_seed:devise generator

* Installs devise
* Generates a User class
* Copies over devise views
* Gives them bootstrap views
* Installs MailPreview for the device mailer.

### Why do you want this?

Devise is a well tested and fully featured way to get user authentication.  The generate sets things up with the defaults, but there are a lot more things to tweak if you are interested.

### Environment Variables

na

### What needs to be done?

Take a look at the user model to see if you want to configure any other features in devise.  Look at the migration to see if there are any other fields you wish the users to have.

Once you feel good about it run "rake db:migrate" and you should be good to go.

## Writing tests

