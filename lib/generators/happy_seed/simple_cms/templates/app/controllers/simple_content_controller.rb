class SimpleContentController < ApplicationController
  def faq
    @faqs = SimpleContent.faqs

    render "splash/faq"
  end
end
