desc 'Counter cache for post has many likes'

task like_counter: :environment do
  Post.reset_column_information
  Post.find_each do |post|
    Post.reset_counters post.id, :likes
  end
end