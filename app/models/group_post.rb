class GroupPost < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :comments, as: :post 
  has_many :post_images, as: :post
  has_many :emotions, as: :post
  
  accepts_nested_attributes_for :post_images

  validates :content, :user, :group_id, presence: true

  default_scope { order(created_at: :desc) }

  delegate :photo, to: :user, prefix: true

  %w(like happy sad mad).each do |emotion|
    define_method "has_#{emotion.pluralize}?" do
      emotions.exists?(emotion: emotion)
    end      
  end  

end
