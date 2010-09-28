# heroku_deploy
This gem is an easy way to quickly setup and
deploy staging and production branches and environments for
your project on heroku.

###Installation Instructions
Install the gem:
    sudo gem install heroku_deploy

In environment.rb
    config.gem "heroku_deploy"

or in your Gemfile
    gem "heroku_deploy"
    gem "heroku"

In your Rakefile:
    begin
      require 'heroku_deploy'
      HerokuDeploy::Tasks.new(
          :staging_app => "example-app-staging",
          :production_app => "example-app")
    rescue LoadError
      puts "heroku_deploy (or a dependency) not available. Install it with: gem install heroku_deploy"
    end

###Setup and Deploy
heroku_deploy assumes that origin/master is your main development branch.  It also assumes your heroku credentials are saved in ~/.heroku/credentials
Once you have that in place, run:

    rake heroku_deploy:setup

This creates two additional branches: staging and production.  These branches hold your deploys.
It also creates the two heroku apps specified in your Rakefile.

Next, deploy to your staging app:

    rake heroku_deploy:staging

Once you've vetted your app at http://example-app-staging.heroku.com, deploy to production:

    rake heroku_deploy:production

It's easy!

Doing a deploy will automatically backup and download your code and database in a heroku bundle.
To back up without deploying, run:

    rake heroku_deploy:backup:staging

or

    rake heroku_deploy:backup:production

To skip the backup when deploying to staging or production run set backup=false:

    rake heroku_deploy:staging backup=false

To skip maintenance mode set maintenance=false:

    rake heroku_deploy:production maintenance=false

You can also define before and after hooks either in your environment or an intializer or pretty much anywhere that gets loaded:

    class HerokuDeploy

      def before_staging_deploy
        `rake asset:packager:build_all`
      end

      def after_production_deploy
        `script/move_latest_backup_to_nas`
      end

    end

###Coming Soon
* Rails 3 compatibility
* Prompts for credentials if you haven't entered them
* No need to include gem "heroku" in your Gemfile
* Better error messages if you're trying to create an existing heroku app

