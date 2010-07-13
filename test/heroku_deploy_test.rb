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

    should 'assign staging_app' do
      assert_equal "example-staging", @tasks.staging_app
    end

    should 'assign production_app' do
      assert_equal "example", @tasks.production_app
    end

    should 'assign a new instance of HerokuDeploy' do
      assert @tasks.heroku_deploy.is_a?(HerokuDeploy)
    end

    should 'set self as the application-wide jeweler tasks' do
      assert_same @tasks, Rake.application.heroku_deploy_tasks
    end
  end

  context 'HerokuDeploy' do

    

  end

end
