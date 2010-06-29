require 'rubygems'
require 'rake'


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "heroku_deploy"
    gem.summary = %Q{initial import}
    gem.description = %Q{Deploy strategy and scripts for Heroku.}
    gem.email = "rosshale@gmail.com"
    gem.homepage = "http://github.com/lottay/heroku_deploy"
    gem.authors = ["Ross Hale", "Chris Lemcke"]
    gem.add_development_dependency "heroku", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "heroku_deploy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
