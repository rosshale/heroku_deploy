require 'rake'
require 'rake/tasklib'

class HerokuDeploy

  class Tasks < ::Rake::TaskLib
    attr_accessor :heroku_deploy

    def initialize
      yield self if block_given?

      self.heroku_deploy = Rake.application.heroku_deploy

      define
    end

    def define
      namespace :heroku_deploy do
        desc 'Setup branches and apps on heroku'
        task :setup => :environment do
          puts "I AM THE SETUP TASK!!"
        end

        desc 'Deploy changes to staging'
        task :staging => :environment do

          Rake::Task['deploy:backup:staging'].invoke

          puts "Deploying to Staging"
          puts "Merging staging with master"

          `git checkout master`
          `git pull origin master`
          `git checkout staging`
          `git pull origin staging`
          `git merge master`
          `git push origin staging`

          heroku_deploy.push_to 'staging'
          puts ""
          puts "Staging Deployed!"
          puts ""
        end

        desc 'Deploy changes to production'
        task :production => :environment do

          Rake::Task['deploy:backup:production'].invoke

          puts "Deploying to Production"
          puts "Merging production with staging"

          `git checkout staging`
          `git pull origin staging`
          `git checkout production`
          `git pull origin production`
          `git merge staging`
          `git push origin production`

          heroku_deploy.push_to 'production'

          puts ""
          puts "Production Deployed!"
          puts ""
        end

        desc 'Backup and download the code and database'
        namespace :backup do
          task :staging => :environment do
            heroku_deploy.backup "grouppay-staging"
          end

          task :production => :environment do
            heroku_deploy.backup "grouppay"
          end
        end

      end
    end
  end

  def push_to( branch )

    app = "grouppay" if branch == "production"
    app = "grouppay-staging" if branch == "staging"

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