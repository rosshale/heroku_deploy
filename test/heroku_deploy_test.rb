require 'test_helper'

require 'rake'
class HerokuDeployTest < Test::Unit::TestCase
  include Rake

  context 'Initializing HerokuDeploy::Tasks' do
    setup do
      @tasks = HerokuDeploy::Tasks.new( :staging_app => "example-staging", :production_app => "example" )
    end

    teardown do
      Task.clear
    end

    should 'set self as the application-wide jeweler tasks' do
      assert_same @tasks, Rake.application.heroku_deploy_tasks
    end

    context "HerokuDeploy instance" do

      setup do
        @heroku_deploy = @tasks.heroku_deploy
        stub(@heroku_deploy).__double_definition_create__.call(:`) { "" }
        stub(@heroku_deploy).puts
        stub(@heroku_deploy).bundle_not_yet_captured? { false }
        stub(@heroku_deploy).bundle_captured? { true }
      end

      should "assign staging_app" do
        assert_equal "example-staging", @heroku_deploy.staging_app
      end

      should "assign production_app" do
        assert_equal "example", @heroku_deploy.production_app
      end

      should "invoke setup" do
        @heroku_deploy.setup
      end

      should "invoke staging" do
        @heroku_deploy.staging
      end

      should "invoke production" do
        @heroku_deploy.production
      end

      should "invoke backup_staging" do
        @heroku_deploy.backup_staging
      end

      should "invoke backup_production" do
        @heroku_deploy.backup_production
      end

    end

  end
end