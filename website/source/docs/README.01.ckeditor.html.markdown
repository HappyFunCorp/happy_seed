HappySeed Ckeditor Email Install
=================

### What does this do?

* Includes ckeditor for editing HTML values.


### Why do you want this?

Easy html body editors

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