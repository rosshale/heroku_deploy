# heroku_deploy
This gem is an easy way to quickly setup and
deploy staging and production environments for
your project on heroku.

###Installation Instructions
Install the gem:
    sudo gem install heroku_deploy

In environment.rb
    config.gem "heroku_deploy"

In your Rakefile:
    begin
      require 'heroku_deploy'
      HerokuDeploy::Tasks.new( :staging_app => "example-app-staging", :production_app => "example-app")
    rescue LoadError
      puts "heroku_deploy (or a dependency) not available. Install it with: gem install heroku_deploy"
    end

