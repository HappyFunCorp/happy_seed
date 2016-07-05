HappySeed ActiveAdmin Install
=============================

### What does this do?

The happy_seed bootstrap generator

* Installs active admin from git
* Runs the active_admin:install generator
* Uses user roles and cancancan to control access
* Optionally creates a seperate AdminUser model
* Creates basic newsletter/campaign admin panel if `MAILCHIMP_API_KEY` is active

### Why do you want this?

ActiveAdmin is a great way to create backend admin tools.  For very complex workflows it may make sense to go custom, but for quickly adding some crud operations it can't be beat.

If you choose to create a seperate AdminUser there is a seperate user universe for admins.  If you want to use the existing devise users, then the happy_seed:roles generator is run and ActiveAdmin is configured to use CanCanCan for all of the models.  This lets you control admin access based upon the `abilities.rb` class.

### Environment Variables

na

### What needs to be done?

Add models to the dashboard by editing app/admin/dashboard.rb to lay out the dashboard, and app/controllers/admin/stats_controller.rb to provide the data.


### Example of using rich text editor

To easily enable editing html content in ActiveAdmin we've included the ckeditor.  Here's a quick example of how you'd add this to the admin tool.

First create a model:

```
rails g scaffold faq title:string body:text position:integer
```

Then create `app/admin/faq.rb`, and define the fields for the form:

ActiveAdmin.register Faq do
  permit_params :title, :body, :position
  
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :title
      f.input :body, as: :ckeditor, input_html: { ckeditor: { height: 400 } }          # builds an input field for every attribute
      f.input :position
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end

