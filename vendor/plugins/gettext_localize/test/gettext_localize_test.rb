require File.dirname(__FILE__) + '/test_helper'

APP_NAME = ""
APP_VERSION = ""

class GettextLocalizeTest < Test::Unit::TestCase

  def test_should_set_and_get_textdomain
    GettextLocalize.textdomain
    GettextLocalize.default_textdomain = 'gettext_localize'
    assert_equal 'gettext_localize', GettextLocalize.textdomain
  end

  def test_should_set_and_get_app
    app_dir = Pathname.new(RAILS_ROOT).realpath.basename.to_s
    assert_equal app_dir, GettextLocalize.app_name
    GettextLocalize.app_name = 'app'
    assert_equal 'app', GettextLocalize.app_name
    GettextLocalize.app_version = '3.2.5'
    assert_equal '3.2.5', GettextLocalize.app_version
    assert_equal 'app 3.2.5', GettextLocalize.app_name_version
    APP_NAME.replace 'new_app'
    assert_equal 'new_app', GettextLocalize.app_name
    assert_equal 'new_app 3.2.5', GettextLocalize.app_name_version
    APP_VERSION.replace '4.3.1'
    assert_equal 'new_app 4.3.1', GettextLocalize.app_name_version
  end

  def test_should_set_and_get_country
    GettextLocalize.set_locale(nil)
    GettextLocalize.default_locale = ''
    GettextLocalize.fallback_locale = ''
    ENV['LANG'] = ''
    GettextLocalize.fallback_country = 'us'
    assert_equal 'us', GettextLocalize.country
    GettextLocalize.default_country = 'es'
    assert_equal 'es', GettextLocalize.country
    ENV['LANG'] = 'en_US'
    assert_equal 'us', GettextLocalize.country
    GettextLocalize.default_locale = 'ca_ES'
    assert_equal 'es', GettextLocalize.country
    GettextLocalize.set_country('us')
    assert_equal 'us', GettextLocalize.country
  end

  def test_should_set_and_get_locale
    GettextLocalize.default_locale = ''
    ENV['LANG'] = ''
    GettextLocalize.fallback_locale = 'ca-es'
    assert_equal 'ca_ES',GettextLocalize.locale
    ENV['LANG'] = 'es_ES@euro'
    assert_equal 'es_ES', GettextLocalize.locale
    GettextLocalize.default_locale = 'en_US'
    assert_equal 'en_US', GettextLocalize.locale
    GettextLocalize.set_country('es')
    GettextLocalize.set_locale('ca')
    assert_equal 'ca_ES', GettextLocalize.locale
  end

  def test_should_survive_to_wrong_country_options
    options = GettextLocalize.get_country_options
    GettextLocalize.set_country_options(nil)
    GettextLocalize.set_country_options('ñaña')
    assert_equal options, GettextLocalize.get_country_options
    # wow!
    GettextLocalize.send(:class_variable_set,:@@country_options,nil)
    assert !GettextLocalize.set_country_options('ñaña')
    # no way! :_)
    GettextLocalize.class_eval do
      class << self
        alias :get_plugin_dir_orig :get_plugin_dir
        def get_plugin_dir(dir=nil) Dir.tmpdir; end
      end
    end
    assert !GettextLocalize.set_country_options('ñaña')
    GettextLocalize.class_eval do
      class << self
        alias :get_plugin_dir :get_plugin_dir_orig
      end
    end
    # let's see how date and time work...
    assert_equal "01-12-2006", Date.new(2006,12,1).strftime("%d-%m-%Y")
    assert_equal "01-12-2006", Time.mktime(2006,12,1).strftime("%d-%m-%Y")
  end

  def test_should_set_and_get_methods
    GettextLocalize.default_methods = nil
    assert_equal [], GettextLocalize.methods
    GettextLocalize.default_methods = "param"
    assert_equal ["param"], GettextLocalize.methods
    GettextLocalize.default_methods = [:param, :session]
    assert_equal [:param, :session], GettextLocalize.methods
  end

  def test_should_survive
    # i know...
    methods = GettextLocalize.send(:class_variable_get,:@@methods).dup
    GettextLocalize.send(:class_variable_set,:@@methods,nil)
    assert [], GettextLocalize.methods
    GettextLocalize.send(:class_variable_set,:@@methods,methods)

    expect = Pathname.new(File.join(RAILS_ROOT,'locale')).realpath.to_s
    assert_equal expect, GettextLocalize.send(:get_locale_path,'.')
    assert GettextLocalize.send(:get_locale_path,'/lopu').nil?
  end

  def test_should_show_available_locales
    all = GettextLocalize.all_locales
    supported = GettextLocalize.supported_locales
    supported.each do |lc|
      assert_equal supported[lc],all[lc]
    end
  end

end
