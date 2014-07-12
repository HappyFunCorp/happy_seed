class Identity < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    identity = find_by(provider: auth.provider, uid: auth.uid)
    identity = create(uid: auth.uid, provider: auth.provider) if identity.nil?
    identity.name = auth.info.name
    identity.email = auth.info.email
    identity.nickname = auth.info.nickname
    identity.image = auth.info.image
    identity.phone = auth.info.phone
    identity.urls = auth.info.urls
    identity.save
    identity
  end
end
