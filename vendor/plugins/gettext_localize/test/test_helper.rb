ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')
require 'logger'
require 'test_help'

plugin_path = RAILS_ROOT + "/vendor/plugins/gettext_localize"

# uses app database config
config_location = RAILS_ROOT + "/config/database.yml"

config = YAML::load(ERB.new(IO.read(config_location)).result)
ActiveRecord::Base.logger = Logger.new(plugin_path + "/test/log/test.log")
ActiveRecord::Base.establish_connection(config['test'])

class Test::Unit::TestCase

  def set_cookie(name,value=nil)
    @request.cookies.delete name if value==nil
    @request.cookies[name.to_s] = CGI::Cookie.new(name.to_s,value.to_s) unless value==nil
  end

end
