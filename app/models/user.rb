class User < ApplicationRecord
  extend FriendlyId
  include Omniauthable
  include Filterable
  include Hashable
  include Emotionable
  acts_as_reader
  has_friendship

  friendly_id :hash_id, use: [:slugged, :finders]

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :omniauthable, :registerable, :confirmable, :secure_validatable, :omniauth_providers => [:facebook]  
  
  enum gender: {男性: 0, 女性: 1, その他: 2}

  AGE = %w(13歳～19歳 20歳～29歳 30歳～34歳 35歳～39歳 40歳～49歳 50歳～64歳 65歳以上)
  SETTING_OPTIONS = %w(公開 友達にのみ公開 非公開)
  PARTNER_RELATIONSHIPS = %w(婚姻 恋人 その他)

  with_options if: :signed_up? do |user|
    user.validates :name, :first_name, :last_name, :first_name_katakana, :last_name_katakana, :gender, :email, :partner_age, :partner_relationship, :cancer_type, :area, presence: true, unless: Proc.new{|u| u.encrypted_password_changed? }
  end

  with_options unless: :display_name_to_everyone? do |user|
    user.validates :nickname, presence: true
  end

  validates :introduction, length: { maximum: 1000 }
  validates :problems, length: { maximum: 1000 }

  mount_uploader :photo, PhotoUploader  
  
  has_many :comments
  has_many :emotions
  has_many :posts, dependent: :destroy
  has_many :post_images, dependent: :destroy  
  has_many :chat_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :groups_owned, class_name: 'Group', foreign_key: :owner_id
  has_many :groups_managing, -> { where(group_memberships: { role: :moderator }) }, through: :group_memberships, source: :group
  has_many :groups, -> { where(group_memberships: { status: 'accepted' }) }, through: :group_memberships
  has_many :group_memberships, dependent: :destroy  
  has_many :group_posts, dependent: :destroy
  has_many :user_treatments, dependent: :destroy
  has_many :treatments, through: :user_treatments
  has_many :children, dependent: :destroy   
  has_many :notifications, foreign_key: :recipient_id

  before_save :set_name!

  accepts_nested_attributes_for :user_treatments, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :treatments, reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :children, reject_if: proc { |attributes| attributes['age'].blank? || attributes['gender'].blank? }, allow_destroy: true

  # Scopes for filtering
  scope :profession, -> (profession){ 
    attribute_is_public("profession_visibility").where(profession: profession) 
  }
  scope :partner_age, -> (partner_age){ 
    attribute_is_public("partner_age_visibility").where(partner_age: partner_age) 
  }
  scope :partner_relationship, -> (partner_relationship){ 
    attribute_is_public("partner_relationship_visibility").where(partner_relationship: partner_relationship) 
  }
  scope :cancer_type, -> (cancer_type){ 
    attribute_is_public("cancer_type_visibility").where(cancer_type: cancer_type) 
  }
  scope :cancer_stage, -> (cancer_stage){ 
    attribute_is_public("cancer_stage_visibility").where(cancer_stage: cancer_stage) 
  }
  scope :hospital, -> (hospital){ 
    attribute_is_public("hospital_visibility").where(hospital: hospital) 
  }
  scope :treatment, -> (treatment){
    attribute_is_public("treatment_visibility")
    .joins(:treatments)
    .where("treatments.name LIKE ?", "#{treatment[0..2]}%") 
    .uniq
  }
  scope :prefecture, -> (prefecture){ 
    attribute_is_public("area_visibility").where(prefecture: prefecture) 
  }
  scope :birthday, -> (birthday){ 
    attribute_is_public("birthday_visibility").where(birthday: birthday) 
  }
  scope :child_age, -> (child_age){ 
    attribute_is_public("children_visibility").joins(:children).where("children.age = ?", child_age) 
  }

  scope :attribute_is_public, ->(attribute) do
    where(
      "users.settings->>:field = :value",
      field: attribute,
      value: User::SETTING_OPTIONS.first
    )
  end

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
    children_visibility String, default: SETTING_OPTIONS.first
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

  def unread_messages
    Message.where(id: chat_rooms.flat_map{|chat_room| chat_room.messages.pluck(:id)})
           .unread_by(self)
  end

  def age
    return nil if birthday.nil?
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if birthday.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end

  def self.name_search(name_search)    
    name_search = "#{name_search[0..3].downcase}%"
    
    attribute_is_public("name_visibility").where("LOWER(name) LIKE ? or LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(first_name_katakana) LIKE ? or LOWER(last_name_katakana) LIKE ? or LOWER(nickname) LIKE ?", name_search, name_search, name_search, name_search, name_search, name_search)
  end

  def self.find_child_by_age_range(min:, max:)    
    return self.where(nil) unless min.present? || max.present?
    min = 0 unless min.present?
    max = 1000 unless max.present?    
    joins(:children).where("children.age >= ? AND children.age <= ?", min, max)
  end

  def joined?(group)
    self.group_memberships.exists?(group_id: group.id, status: :accepted)
  end

  def pending_requests
    HasFriendship::Friendship.where(friend_id: self.id, status: :pending).order(created_at: :desc)
  end

  def sent_requests
    HasFriendship::Friendship.where(friendable_id: self.id, status: :pending).order(created_at: :desc)
  end

  def accept_request(friend)
    super
    return if ChatRoom.exists_for?(user: self, member: friend)
    chat_rooms.create! member: friend, user: self
  end

  def chat_rooms
    ChatRoom.where("member_id = ? or user_id = ?", id, id)    
  end

  def posts_visible_for(current_user:)     
    return posts.includes(:post_images, :user, comments: [:user, :post]) if self == current_user 
    return (posts.includes(:post_images, :user, comments: [:user, :post])
                .visible_to_friends + 
            posts.includes(:post_images, :user, comments: [:user, :post])
                .visible_to_everyone).sort_by(&:created_at)
                                     .reverse if self.friends_with?(current_user) 

    posts.includes(:post_images, :user, comments: [:user, :post]).visible_to_everyone
  end

  def treatment_options
    Treatment.default + treatments.where(default: false)
  end

  private  

  def display_name_to_everyone?
    name_visibility == SETTING_OPTIONS.first
  end

  def signed_up?   
    created_at.present? && profile_completed?
  end

  def set_name!    
    self.name = "#{last_name}#{first_name}"
  end

end
