if !ENV['MAILCHIMP_API_KEY'].blank?
  ActiveAdmin.register_page "Campaigns" do
    menu parent: "Newsletter"

    content do
      @c = {}
      if params[:list_id]
        @c = Gibbon::API.new.campaigns.list( :filters => { :list_id => params[:list_id] } )
      elsif params[:campaign_id]
        @c = Gibbon::API.new.campaigns.list( :filters => { :campaign_id => params[:campaign_id] } )
      else
        @c = Gibbon::API.new.campaigns.list
      end

      data = @c['data'].each do |d| 
        d['summary'] = {} if d['summary'].is_a? Array
      end
      table_for data do #.sort { |a,b| a['send_time'] <=> b['send_time'] } do
        column( "list_id" ) { |d| d['list_id']}
        column( "title" ) { |d| d['title'] }
        column( "created" ) { |d| d['create_time'] }
        column( "sent" ) { |d| d['send_time'] }
        column( "subject" ) { |d| d['subject'] }
        column( "emails sent") { |d| d['emails_sent'] }
        column( "opens" ) { |d| d['summary']['opens'] }
        column( "clicks" ) { |d|  d['summary']['clicks'] }
        column( "UUser Clicks" ) { |d| d['summary']['users_who_clicked'] }
        column( "last click" ) { |d|  d['summary']['last_click'] }
      end
    end

    action_item do
      link_to "Go to Mailchimp", "https://login.mailchimp.com/"
    end
  end
end