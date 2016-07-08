HappySeed Ckeditor Email Install
=================

### What does this do?

* Includes ckeditor, a WYSIWYG editor for adding html to your documents. For a detailed explanation of everything you can do with ckeditor see the documentation for the gem [here.](https://github.com/galetahub/ckeditor)


### Why do you want this?

Easy html body editor for when you need to add html content through your admin panel/form/etc. Ckeditor is a great solution for this and makes it very easy.

### Environment Variables

n/a

### What needs to be done?

Pass in :ckeditor to simple_form.

```
$ rails g scaffold post title:string body:text 
```

```
= simple_form_for(@post) do |f|
  = f.error_notification

  .form-inputs
    = f.input :title
    = f.input :body, as: :ckeditor

  .form-actions
    = f.button :submit
```
