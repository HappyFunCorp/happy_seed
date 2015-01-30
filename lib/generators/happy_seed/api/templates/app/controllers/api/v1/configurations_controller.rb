class Api::V1::ConfigurationsController < Api::V1::BaseController
  before_action :requires_authentication_token

  def show
    respond_to do |format|
      format.json do
        render json: configuration_hash, status: :ok
      end
    end
  end
end