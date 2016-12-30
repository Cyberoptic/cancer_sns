desc 'Counter cache for post has many happies'

task happy_counter: :environment do
  Post.reset_column_information
  Post.find_each do |post|
    Post.reset_counters post.id, :happies
  end
end