

  def show_content( key, title = nil, &block  )
    content = SimpleContent.where( key: key ).first

    if @debug_content
      content = nil
    end

    if content.nil?
      pos = output_buffer.length
      yield
      fragment = output_buffer.slice( pos..-1 )
      content = SimpleContent.create( key: key, body: fragment, title: title )
    else
      safe_concat content.body
    end
  end