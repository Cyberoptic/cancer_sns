module Omniauthable
  extend ActiveSupport::Concern

  included do
    has_many :emotions
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"]        
        user.provider = data["provider"]
        user.uid = data["uid"]
        user.email = data["info"]["email"] if user.email.blank?
        user.password = Devise.friendly_token[0,20]
        user.first_name = data["info"]["name"].split.first
        user.last_name = data["info"]["name"].split.last
        user.photo = data["info"]["image"]
      end
    end
  end

  def self.from_omniauth(auth)    
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.name.split.first
      user.last_name = auth.info.name.split.last
      user.photo = auth.info.image      
    end
  end

  # If sign in through Oauth, don't require password
  def password_required?    
    super && provider.blank?
  end

  # Don't require update with password if Oauth
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
