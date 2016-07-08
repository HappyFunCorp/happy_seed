HappySeed Roles Install
===================

### What does this do?

The `happy_seed:roles` generator

* Installs cancancan
* Created an enum on the User model ( :user and :admin )
* Creates a basic `abilities.rb` file
* Adds a generic `access_denied` method on `application_controller`

### Why do you want this?

This is a basic framework for role-based permissions.  The admin generator will optionally use this if you don't install a seperate AdminUser class.

### Environment Variables

na

### What needs to be done?

Define roles in the enum on the user model and abilities inside of the `abilities.rb` class per the directions in the cancan documentation [here.](https://github.com/ryanb/cancan/wiki/Defining-Abilities)  
