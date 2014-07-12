module ApplicationHelper
  def flash_class(level)
    case level.to_sym
        when :notice then "alert alert-info"
        when :success then "alert alert-success"
        when :alert then "alert alert-warning"
        when :error then "alert alert-danger"
        else "alert-danger alert"
    end
  end

  def error_for( model_class, attribute, err_class )
    if model_class.errors[attribute].size > 0
      err_class
    else
      nil
    end
  end

  def page_title
    @title || controller_name.gsub( /Controller/, "" ).humanize
  end
end
