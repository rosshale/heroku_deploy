# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{heroku_deploy}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ross Hale", "Chris Lemcke"]
  s.date = %q{2010-06-29}
  s.description = %q{Deploy strategy and scripts for Heroku.}
  s.email = %q{rosshale@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".gitignore",
     ".idea/encodings.xml",
     ".idea/heroku_deploy.iml",
     ".idea/misc.xml",
     ".idea/modules.xml",
     ".idea/vcs.xml",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "config/heroku_deploy.yml",
     "heroku_deploy.gemspec",
     "lib/heroku_deploy.rb",
     "lib/tasks/heroku_deploy.rake"
  ]
  s.homepage = %q{http://github.com/lottay/heroku_deploy}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{initial import}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<heroku>, [">= 0"])
    else
      s.add_dependency(%q<heroku>, [">= 0"])
    end
  else
    s.add_dependency(%q<heroku>, [">= 0"])
  end
end

