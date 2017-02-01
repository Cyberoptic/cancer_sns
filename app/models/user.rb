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
  has_many :user_treatments, dependent: :destroy
  has_many :treatments, through: :user_treatments
  has_many :children, dependent: :destroy 
  has_many :emotions

  accepts_nested_attributes_for :user_treatments, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :treatments, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :children, reject_if: proc { |attributes| attributes['age'].blank? }

  # Scopes for filtering
  scope :profession, -> (profession){ where(profession: profession) }
  scope :partner_age, -> (partner_age){ where(partner_age: partner_age) }
  scope :cancer_type, -> (cancer_type){ where(cancer_type: cancer_type) }
  scope :cancer_stage, -> (cancer_stage){ where(cancer_stage: cancer_stage) }
  scope :hospital, -> (hospital){ where(hospital: hospital) }
  scope :treatment, -> (treatment){ 
    self.joins(:treatments)
        .where("treatments.name LIKE ?", "#{treatment[0..2]}%") 
        .uniq
  }
  scope :birthday, -> (birthday){ where(birthday: birthday) }
  scope :name_search, -> (name_search){
    where("LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(first_name_katakana) LIKE ? or LOWER(last_name_katakana) LIKE ?", "#{name_search}%", "#{name_search}%", "#{name_search}%", "#{name_search}%")
  }

  # Settings
  include Storext.model
  store_attributes :settings do
    profession_visibility String, default: SETTING_OPTIONS.first
    partner_age_visibility String, default: SETTING_OPTIONS.first
    partner_relationship_visibility String, default: SETTING_OPTIONS.first
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

  def emotioned_on?(post)
    liked?(post) || sadded?(post) || happied?(post) || madded?(post)
  end

  Emotion.emotions.keys.each do |emotion|
    define_method "#{emotion}" do |post|
      @emotion = emotions.find_or_initialize_by(post_id: post.id, post_type: post.class.name)

      if @emotion.new_record?
        @emotion.emotion = emotion
        @emotion.save!        
      else
        @emotion.update(emotion: emotion)
      end
    end      
  end

  Emotion.emotions.keys.each do |emotion|
    define_method "un#{emotion}" do |post|
      emotions.find_by(post_id: post.id, post_type: post.class.name, emotion: emotion).destroy
    end      
  end

  def liked?(post)
    post.emotions.exists?(user_id: self.id, emotion: "like")
  end

  def sadded?(post)    
    post.emotions.exists?(user_id: self.id, emotion: "sad")
  end

  def happied?(post)
    post.emotions.exists?(user_id: self.id, emotion: "happy")
  end

  def madded?(post)
    post.emotions.exists?(user_id: self.id, emotion: "mad")
  end

  def joined?(group)
    self.group_memberships.exists?(group_id: group.id)
  end

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
    return posts.includes(:post_images) if self == current_user 
    return posts.includes(:post_images).visible_to_friends + posts.includes(:post_images).visible_to_everyone if self.friends_with?(current_user) 

    posts.includes(:post_images).visible_to_everyone
  end

  def treatment_options
    Treatment.default + treatments.where(default: false)
  end

  def to_param
    Hashids.new("this is my salt").encode(id)
  end

  private

  def display_name_to_everyone?
    name_visibility == SETTING_OPTIONS.first
  end

  def signed_up?   
    created_at.present? && profile_completed?
  end

end
