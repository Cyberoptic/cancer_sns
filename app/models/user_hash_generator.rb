class UserHashGenerator
  def generate
    hash_id = nil
    loop do
      hash_id = SecureRandom.urlsafe_base64(9).gsub(/-|_/,('a'..'z').to_a[rand(26)])
      break unless User.where(hash_id: hash_id).exists?
    end

    hash_id
  end
end