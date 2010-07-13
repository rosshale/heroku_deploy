require 'test/unit'
require 'rubygems'

require 'rake'
require 'shoulda'
require 'rr'
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'heroku_deploy'


class Test::Unit::TestCase
  include RR::Adapters::TestUnit unless include?(RR::Adapters::TestUnit)
end
