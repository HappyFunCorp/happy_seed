<% if namespaced? -%> 
require_dependency "<%= namespaced_file_path %>/application_controller"
<% end -%> 
<% module_namespacing do -%> 
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
  end 

  def show
  end 

  def new 
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end 

  def edit
  end 

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
    @<%= orm_instance.save %>
    respond_with(@<%= singular_table_name %>)
  end 

  def update
    @<%= orm_instance.update("#{singular_table_name}_params") %>
    flash[:notice] = <%= "'#{human_name} was successfully updated.'" %>
    respond_with(@<%= singular_table_name %>)
  end 

  def destroy
    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end 

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end 

    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>] 
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>) 
      <%- end -%>
    end 
end
<% end -%> 
