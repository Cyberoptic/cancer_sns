namespace :emotions do
  task :reset do 
    Post.update_all(sads_count: 0, likes_count: 0, mads_count: 0, happies_count: 0)
    GroupPost.update_all(sads_count: 0, likes_count: 0, mads_count: 0, happies_count: 0)

    Post.all.each do |post|
      post.emotions.each do |emotion|        
        post["#{emotion.emotion.pluralize}_count"] += 1
      end
      post.save
    end

    GroupPost.all.each do |post|
      post.emotions.each do |emotion|
        post["#{emotion.emotion.pluralize}_count"] += 1
      end
      post.save
    end
  end
end