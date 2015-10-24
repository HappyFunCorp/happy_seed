if !ENV['MAILCHIMP_API_KEY'].blank?
  ActiveAdmin.register_page "Campaigns" do
    menu parent: "Newsletter"

    content do
      @c = {}
      gb = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
      if params[:list_id]
        @c = gb.campaigns.retrieve( params: {list_id: params[:list_id]}  )
      elsif params[:campaign_id]
        @c = gb.campaigns.retrieve( params: {campaign_id: params[:campaign_id]}  )
      else
        @c = gb.campaigns.retrieve
      end

      table_for @c['campaigns'] do
        column( "subject" ) { |d| d['settings']['subject_line'] }
        column( "title" ) { |d| d['settings']['title'] }
        column( "created" ) { |d| d['create_time'] }
        column( "sent" ) { |d| d['send_time'] }
        column( "emails sent") { |d| d['emails_sent'] }
        column( "opens" ) { |d| d['report_summary'] && d['report_summary']['opens'] }
        column( "clicks" ) { |d|  d['report_summary'] && d['report_summary']['clicks'] }
        column( "unique_opens" ) { |d| d['report_summary'] && d['report_summary']['unique_opens'] }
      end
    end

    action_item do
      link_to "Go to Mailchimp", "https://login.mailchimp.com/"
    end
  end
end