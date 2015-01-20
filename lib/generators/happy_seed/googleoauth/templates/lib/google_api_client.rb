class GoogleApiClient
  def self.client( identity )
    client = Google::APIClient.new(:application_name => 'HappySeed App', :application_version => "1.0.0" )
    client.authorization.update_token!({:access_token => identity.accesstoken, :refresh_token => identity.refreshtoken})
    client
  end
end