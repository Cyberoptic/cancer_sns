class User < ApplicationRecord
  include Filterable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :registerable, :confirmable, :secure_validatable, :omniauth_providers => [:facebook]
  
  enum gender: {男性: 0, 女性: 1, その他: 2}

  AGE = %w(13歳～19歳 20歳～29歳 30歳～34歳 35歳～39歳 40歳～49歳 50歳～64歳 65歳以上)
  SETTING_OPTIONS = %w(公開 友達にのみ公開 非公開)
  PARTNER_RELATIONSHIPS = %w(婚姻 恋人 その他)

  with_options if: :signed_up? do |user|
    user.validates :first_name, :last_name, :first_name_katakana, :last_name_katakana, :gender, :email, :partner_age, :partner_relationship, :cancer_type, :area, presence: true, unless: Proc.new{|u| u.encrypted_password_changed? }
  end

  with_options unless: :display_name_to_everyone? do |user|
    user.validates :nickname, presence: true
  end

  validates :introduction, length: { maximum: 1000 }

  mount_uploader :photo, PhotoUploader
  
  has_friendship
  
  has_many :comments
  has_many :posts, dependent: :destroy
  has_many :post_images, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :sads, dependent: :destroy
  has_many :happies, dependent: :destroy
  has_many :chat_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :group_memberships, dependent: :destroy
  has_many :group_posts, dependent: :destroy

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
    profession_visibility String, default: SETTING_OPTIONS.first
    partner_age_visibility String, default: SETTING_OPTIONS.first
    cancer_type_visibility String, default: SETTING_OPTIONS.first
    cancer_stage_visibility String, default: SETTING_OPTIONS.first
    hospital_visibility String, default: SETTING_OPTIONS.first
    treatment_visibility String, default: SETTING_OPTIONS.first
    birthday_visibility String, default: SETTING_OPTIONS.first
    problems_visibility String, default: SETTING_OPTIONS.first
    area_visibility String, default: SETTING_OPTIONS.first
    name_visibility String, default: SETTING_OPTIONS.first
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

######################################################################
################### Emotions section BEGIN ###########################

  def like(post)
    likes.create({post_id: post.id, post_type: post.class.name})
  end

  def unlike(post)
    likes.find_by(post_id: post.id, post_type: post.class.name).destroy
  end

  def sad(post)
    sads.create({post_id: post.id, post_type: post.class.name})
  end

  def unsad(post)
    sads.find_by(post_id: post.id, post_type: post.class.name).destroy
  end

  def happy(post)
    happies.create({post_id: post.id, post_type: post.class.name})
  end

  def unhappy(post)
    happies.find_by(post_id: post.id, post_type: post.class.name).destroy
  end

  def liked?(post)
    post.likes.exists?(user_id: self.id)
  end

  def sadded?(post)    
    post.sads.exists?(user_id: self.id)    
  end

  def happied?(post)
    post.happies.exists?(user_id: self.id)    
  end

######################################################################
##################### Emotions section END ###########################



##################### GROUPs ###########################

def joined?(group)
  self.group_memberships.exists?(group_id: group.id)
end

##################### GROUPs END ###########################

  def pending_requests
    HasFriendship::Friendship.where(friend_id: self.id, status: :pending).order(created_at: :desc)
  end

  def accept_request(friend)
    super
    chat_rooms.create! member: friend, user: self
  end

  def chat_rooms
    ChatRoom.where("member_id = ? or user_id = ?", id, id)    
  end

  def posts_visible_for(current_user:)  
    return posts if self == current_user 
    return posts.visible_to_friends + posts.visible_to_everyone if self.friends_with?(current_user) 

    posts.visible_to_everyone
  end

  private

  def display_name_to_everyone?
    name_visibility == SETTING_OPTIONS.first
  end

  def signed_up?   
    created_at.present? && profile_completed?
  end

end
