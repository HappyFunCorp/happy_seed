HappySeed SimpleCms Install
=====================

### What does this do?

The `happy_seed:simple_cms` generator depends upon `happy_seed:splash` and `happy_seed:admin` and installs a basic cms by creating a SimpleContent model and a helper method called `show_content` you can use in your views.

### Why do you want this?

It creates a very simple CMS that allows you to change content easily. It makes it especially easy for sites where content changes often. This allows you to easily put in the base content and allow users to update at their liesure so you can focus on building and not tweaking copy.

### Environment Variables

None needed. However, see below on how to use the `@debug_content` instance variable with the `show_content` method.

### What needs to be done?

In addition to creating the active admin interface for modifying content and the SimpleContent model, the main helper it creates is the `show_content` method that you can use in your haml views as follows:

```
-show_content :my_content_title do
  %p This is my example content...
```

This allows you to create an editable block anywhere in your views that you can update via the cms.

What this does is check to see if `SimpleContent.where(key: :my_content_title).first` exists. If it does, it will load that content, if not it will create that content in the database under that key and insert it in your view.

This way you don't have to worry about adding things through active_admin to populate base content,  you just define it in your view and when that view gets compiled the first time, it will be saved to the database for future editing.

You can set the `@debug_content` variable to true at the top of your view when you are testing locally so that you can make sure things are saving correctly and will continue to save more than just the first time.

