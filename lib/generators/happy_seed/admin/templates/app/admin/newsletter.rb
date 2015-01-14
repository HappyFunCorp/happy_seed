if !ENV['MAILCHIMP_API_KEY'].blank?
  ActiveAdmin.register_page "Newsletter"  do
    content do
      if !params[:list_id]
        @lists = Gibbon::API.new.lists.list

        panel "MailChimp Lists" do
          table_for @lists['data'] do
            column( "name" ) { |d| d['name'] }
            column( "members" ) { |d| d['stats']['member_count'] }
            column( "unsubscribe_count") { |d| d["stats"]["unsubscribe_count"] }
            column( "new members") { |d| d["stats"]["member_count_since_send"] }
            column( "campaigns") do |d|
              link_to "View #{d["stats"]["campaign_count"]} Campaigns", admin_campaigns_path( :list_id => d['id'] )
            end
            column( "open_rate") { |d| sprintf "%.2f%", d["stats"]["open_rate"] }
            column( "click_rate") { |d| sprintf "%.2f%", d["stats"]["click_rate"] }
            column( "created" ) { |d| d['date_created'] }
            # column( "action" ) do |d|
            #   link_to "Send Message", admin_newsletter_create_message_path( list_id: d['id'] ), class: "button"
            # end
          end
        end
      else
        render partial: "create_message"
      end
    end

    action_item do
      link_to "Go to Mailchimp", "https://login.mailchimp.com/"
    end

    # page_action :create_message do
    #   redirect_to admin_newsletter_path( list_id: params[:list_id] )
    # end

    # page_action :send_message, method: :post do
    #   if params[:list_id].blank? || params[:subject].blank? || params[:message].blank?
    #     redirect_to admin_newsletter_path, notice: "Message NOT sent, missing params"
    #   end

    #   puts "Sending message: #{params[:subject]}"
    #   puts "Body: #{params[:message]}"

    #   redirect_to admin_newsletter_path, notice: "Message sent!"
    # end
  end
end