staging_app     = 'boiling-ravine-74670'
production_app  = 'cancer-partners'

namespace :deploy do
  namespace :production do
    task :promote do
      start_time = Time.now

      Bundler.with_clean_env do
        # puts "Maintenance On"
        # puts `heroku maintenance:on -a #{production_app}`

        puts "Promoting Staging to Production"
        puts `heroku pipelines:promote -a #{staging_app}`

        puts "Migrate Production Database"
        puts `heroku run rake db:migrate -a #{production_app}`

        puts "Precompile Production Assets"
        puts `heroku run rake assets:precompile -a #{production_app}`

        puts "Restart Production"
        puts `heroku restart -a #{production_app}`

        # puts "Maintenance Off"
        # puts `heroku maintenance:off -a #{production_app}`
      end

      puts "[#{Time.now - start_time}] Total Time"
    end
  end
end