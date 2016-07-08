class SimpleContent < ApplicationRecord
  def self.faqs
    where( "key like 'faq.%'").order( "priority asc")
  end
end
