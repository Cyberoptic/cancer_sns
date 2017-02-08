module Hashable
  extend ActiveSupport::Concern

  included do
    before_create :set_hash_id!
  end

  # set hash_id for user to use in slug
  def set_hash_id!
    hash_id = nil
    loop do
      hash_id = SecureRandom.urlsafe_base64(9).gsub(/-|_/,('a'..'z').to_a[rand(26)])
      break unless self.class.name.constantize.where(hash_id: hash_id).exists?
    end

    self.hash_id = hash_id
  end
end
