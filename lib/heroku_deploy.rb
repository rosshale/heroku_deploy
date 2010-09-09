class HerokuDeploy
  autoload :Tasks, 'heroku_deploy/tasks'
  autoload :HerokuDeploy, 'heroku_deploy/tasks'
  autoload :HTTParty, 'httparty'
end
