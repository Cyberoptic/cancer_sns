class User < ApplicationRecord
  include Filterable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :omniauth_providers => [:facebook]

  devise :registerable, :confirmable
  
  enum gender: {男性: 0, 女性: 1, その他: 2}
  AGE = 16..100

  with_options if: :signed_up? do |user|
    user.validates :first_name, :last_name, :first_name_katakana, :last_name_katakana, :gender, :email, :partner_age, :cancer_type, :cancer_stage, presence: true    
  end

  with_options if: :name_hidden? do |user|
    user.validates :nickname, presence: true
  end

  mount_uploader :photo, PhotoUploader

  has_many :posts
  has_many :post_images

  scope :is_public, -> { where(is_public: true) }

  # Scopes for filtering
  scope :profession, -> (profession){ where(profession: profession) }
  scope :partner_age, -> (partner_age){ where(partner_age: partner_age) }
  scope :cancer_type, -> (cancer_type){ where(cancer_type: cancer_type) }
  scope :cancer_stage, -> (cancer_stage){ where(cancer_stage: cancer_stage) }
  scope :hospital, -> (hospital){ where(hospital: hospital) }
  scope :treatment, -> (treatment){ where(treatment: treatment) }
  scope :birthday, -> (birthday){ where(birthday: birthday) }

  # Settings
  include Storext.model
  store_attributes :settings do
    show_profession Boolean, default: false
    show_partner_age Boolean, default: false
    show_cancer_type Boolean, default: true
    show_cancer_stage Boolean, default: true
    show_hospital Boolean, default: false
    show_treatment Boolean, default: true
    show_birthday Boolean, default: false
    show_problems Boolean, default: true
    show_area Boolean, default: true
    show_name Boolean, default: true
  end

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

  private

  def name_hidden?
    # implement later
    false
  end

  def signed_up?
    !created_at.nil?
  end

end
