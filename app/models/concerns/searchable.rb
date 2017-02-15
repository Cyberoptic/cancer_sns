module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end

  def self.search(*args)
    __elasticsearch__.search(*args)
  end
end
