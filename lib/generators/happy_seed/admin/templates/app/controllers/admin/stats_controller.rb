class Admin::StatsController < ApplicationController
  before_filter :authenticate_admin_user!

  def stats
    if params[:scope].blank?
      render :json => { :errors => "scope not set" }, :status => 422
    else
      cls = User
      cls = Identity.where( "provider = ?", "twitter" ) if params[:scope] == 'twitter_users'
      cls = Identity.where( "provider = ?", "instagram" ) if params[:scope] == 'instagram_users'
      ret = cls.group_by_month
      render json: ret
    end
  end
end