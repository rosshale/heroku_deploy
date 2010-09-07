# heroku_deploy
This gem is an easy way to quickly setup and
deploy staging and production branches and environments for
your project on heroku.

###Installation Instructions
Install the gem:
    sudo gem install heroku_deploy

In environment.rb
    config.gem "heroku_deploy"

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
heroku_deploy assumes that origin/master is your main development branch.  Once you have that in place, run:

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

To skip the backup when deploying to staging or production run:

    rake heroku_deploy:staging backup=false

###Coming Soon
* Before and after hooks that allow you to arbitrarily execute code before and after deploy
