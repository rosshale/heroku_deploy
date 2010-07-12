require 'rake'
require 'rake/tasklib'

class Rake::Application
  attr_accessor :heroku_deploy_tasks

  def heroku_deploy
    heroku_deploy_tasks.heroku_deploy
  end
end

class HerokuDeploy

  class Tasks < ::Rake::TaskLib
    attr_accessor :heroku_deploy, :staging_app, :production_app

    def initialize( options = {} )
      Rake.application.heroku_deploy_tasks = self

      @staging_app = options.delete(:staging_app)
      @production_app = options.delete(:production_app)
      
      define
    end

    def define
      namespace :heroku_deploy do
        desc 'Setup branches and apps on heroku'
        task :setup => :environment do

          puts ""
          puts "Creating staging branch"
          puts ""
          `git branch staging`
          `git push origin origin/master:refs/heads/staging`

          puts ""
          puts "Creating production branch"
          puts ""
          `git branch production`
          `git push origin origin/master:refs/heads/production`

          `git checkout master`

          puts ""
          puts "Creating #{staging_app} Heroku app"
          puts ""
          `heroku app:create #{staging_app}`

          puts ""
          puts "Creating #{production_app} Heroku app"
          puts ""
          `heroku app:create #{production_app}`

          puts ""
          puts "Setup Complete!"
          puts ""

        end

        desc 'Deploy changes to staging'
        task :staging => :environment do

          heroku_deploy.backup( staging_app )

          puts "Deploying to Staging"
          merge( "master", "staging" )

          heroku_deploy.push_to 'staging', staging_app
          puts ""
          puts "Staging Deployed!"
          puts ""
        end

        desc 'Deploy changes to production'
        task :production => :environment do

          heroku_deploy.backup( production_app )

          puts "Deploying to Production"
          merge( "staging", "production" )

          heroku_deploy.push_to 'production', production_app

          puts ""
          puts "Production Deployed!"
          puts ""
        end

        namespace :backup do
          desc 'Backup and download the staging code and database in a heroku bundle'
          task :staging => :environment do
            heroku_deploy.backup "grouppay-staging"
          end

          desc 'Backup and download the production code and database in a heroku bundle'
          task :production => :environment do
            heroku_deploy.backup "grouppay"
          end
        end

      end
    end
  end

  def merge(from_branch, to_branch)
    puts "Merging #{from_branch} with #{to_branch}"

    `git checkout #{from_branch}`
    `git pull origin #{from_branch}`
    `git checkout #{to_branch}`
    `git pull origin #{to_branch}`
    `git merge #{from_branch}`
    `git push origin #{to_branch}`
  end

  def push_to( branch, app )

    puts "Going into maintenance mode"

    `heroku maintenance:on --app #{app}`

    puts "Pushing to #{app}"

    `git push git@heroku.com:#{app}.git #{branch}:master`
    `git checkout master`

    puts "Migrating"

    `heroku rake db:migrate --app #{app}`

    puts "Restarting"

    `heroku restart --app #{app}`

    puts "Getting out of maintenance mode"

    `heroku maintenance:off --app #{app}`

  end

  def backup( app )
    puts ""
    puts "Beginning Backup"
    timestamp = Time.now.to_s(:number)
    old_bundle = `heroku bundles --app #{app}`.split.first

    `heroku bundles:destroy #{old_bundle} --app #{app}`
    puts "Old Bundle Destroyed"
    `heroku bundles:capture backup-#{timestamp} --app #{app}`
    puts "New Bundle Captured on Heroku: backup-#{timestamp}"

    while !`heroku bundles --app #{app}`.include?("complete") do
    end

    puts "New Bundle Ready For Download"

    `heroku bundles:download backup-#{timestamp} --app #{app}`
    `mv #{app}.tar.gz #{app}-#{timestamp}.tar.gz`

    puts "New Bundle Downloaded: #{app}-#{timestamp}.tar.gz"

    puts "Backup Complete!"
    puts ""

  end

end