class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:facebook]

  #uncomment this in production
  #devise :registerable, :confirmable
  
  enum gender: {female: 0, male: 1, other: 2}

  # validates :first_name, :last_name, :first_name_katakana, :last_name_katakana, :birthday, :gender, :email, :partner_age, :cancer_type, :cancer_stage, :treatment, presence: true

  mount_uploader :photo, PhotoUploader
  
  has_friendship

  has_many :posts
  has_many :post_images


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.first_name = data["name"].split.first if user.first_name.blank?
        user.last_name = data["name"].split.last if user.last_name.blank?
        # user.password = data["password"] not sure if this attribute exists
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # binding.pry
      user.first_name = auth.info.name.split.first   # assuming the user model has a name
      user.last_name = auth.info.name.split.last
      user.photo = auth.info.image # assuming the user model has an image
    end
  end

end
