module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end

  module ClassMethods
    def search(*args)
      __elasticsearch__.search(*args)
    end
  end
end
