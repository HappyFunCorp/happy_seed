HappySeed Devise Confirmable Install
===================

### What does this do?

The `happy_seed:devise_confirmable` generator

* Installs devise_confirmable
* Adds columns to track if the user has been confirmed
* Copies over devise views
* Gives them bootstrap views

### Why do you want this?

This allows you to confirm users through an email link and checks to make sure they are confirmed when logging in. For more information on devise and confirmable, check out the docs [here.](https://github.com/plataformatec/devise)

### Environment Variables

na

### What needs to be done?

Be aware that if you are running this generator after you already have users, you may want to mark existing users as already confirmed. Please read the comments in the migration and uncomment the line `execute("UPDATE users SET confirmed_at = NOW()") ` before running the migration.  For futher information consult [these docs.](https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users)
