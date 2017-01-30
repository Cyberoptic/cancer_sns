require 'elasticsearch/model'

class Group < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  validates :name, presence: true
  has_many :group_posts, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
end
