ActiveAdmin.register SimpleContent do
  menu priority: 3, label: "Content"
  permit_params :key, :title, :body, :priority
  
  index do
    selectable_column
    column :key do |content|
      link_to content.key, edit_admin_simple_content_path(content)
    end
    column :title do |content|
      link_to content.title, edit_admin_simple_content_path(content)
    end
    column :body
    column :priority
  end

  sidebar :faqs, priority: 0 do
    ul do
      SimpleContent.faqs.each do |content|
        li( link_to( content.title, edit_admin_simple_content_path( content )))
      end
    end

    p "Keys that start with 'faq.' are part of the faq, ordered by priority"
  end

  action_item :see_faq do
    link_to "View Faq", faq_path
  end

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :key
      f.input :title
      f.input :body, as: :ckeditor, input_html: { ckeditor: { height: 400 } }          # builds an input field for every attribute
      f.input :priority
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end

