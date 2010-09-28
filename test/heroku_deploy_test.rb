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
        stub(@heroku_deploy).maintenance_off { false }
        stub(@heroku_deploy).maintenance_on { false }
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

      should "invoke backup_staging" do
        @heroku_deploy.backup_staging
      end

      should "invoke backup_production" do
        @heroku_deploy.backup_production
      end

      should "have access to httparty" do
        assert HTTParty
      end

      context "with backup" do

        should "invoke staging and backup" do
          mock.proxy(@heroku_deploy).backup("example-staging")
          @heroku_deploy.staging
        end

        should "invoke production and backup" do
          mock.proxy(@heroku_deploy).backup("example")
          @heroku_deploy.production
        end
      end

      context "without backup" do

        should "invoke staging and skip backup" do
          ENV['BACKUP'] = "false"
          dont_allow(@heroku_deploy).backup("example-staging")
          @heroku_deploy.staging
        end

        should "invoke production and skip backup" do
          ENV['backup'] = "false"
          dont_allow(@heroku_deploy).backup("example")
          @heroku_deploy.production
        end
      end

      context "without maintenance mode" do
        should "invoke staging and skip maintenance" do
          ENV['MAINTENANCE'] = "false"
          dont_allow(@heroku_deploy).go_into_maintenance("example-staging")
          dont_allow(@heroku_deploy).get_out_of_maintenance("example-staging")
          @heroku_deploy.staging
        end

        should "invoke production and skip backup" do
          ENV['maintenance'] = "false"
          dont_allow(@heroku_deploy).go_into_maintenance("example")
          dont_allow(@heroku_deploy).get_out_of_maintenance("example")
          @heroku_deploy.production
        end
      end

    end

  end
end
