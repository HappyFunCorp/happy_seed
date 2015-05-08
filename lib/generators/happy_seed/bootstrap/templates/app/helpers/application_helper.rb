module ApplicationHelper
  def flash_class(level)
    case level.to_sym
        when :notice then "alert-info"
        when :success then "alert-success"
        when :alert then "alert-warning"
        when :error then "alert-danger"
        else "alert-danger"
    end
  end

  def page_title
    @title || controller_name.gsub( /Controller/, "" ).humanize
  end
end
