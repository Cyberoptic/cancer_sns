desc 'Counter cache for post has many sads'

task sad_counter: :environment do
  Post.reset_column_information
  Post.find_each do |post|
    Post.reset_counters post.id, :sads
  end
end