# general gettext definition functions.
# order in wich GettextLocalize tries to load options
#
# locale:
#   - cookie set with name 'lang'
#   - locale set in controller with set_locale(lang)
#   - locale set in environment with GettextLocalize::default_locale = lang
#   - locale set in environment variable $LANG
#   - locale set in this plugin init.rb with GettextLocalize::fallback_locale = lang
#
# country
#   - cookie set with name 'country'
#   - country set in controller with set_country(country)
#   - country set in environment with GettextLocalize::default_country = country
#   - country part of locale
#   - country set in this plugins init.rb with GettextLocalize::fallback_country = country
#
# textdomain:
#   - textdomain set in plugin using plugin_bindtextdomain(textdomain)
#     uses loadpath RAILS_ROOT/vendor/plugins/$plugin/locale
#   - textdomain set in controller with init_gettext(textdomain)
#     uses loadpath RAILS_ROOT/locale
#   - textdomain set in environment.rb with GettextLocalize::default_textdomain = textdomain
#   - app_name set in environment.rb with GettextLocalize::app_name = app
#   - name of the directory the rails app is in
#
module GettextLocalize

  private

  @@country = nil
  @@default_country = nil
  @@fallback_country = nil

  @@locale = nil
  @@original_locale = nil
  @@default_locale = nil
  @@fallback_locale = nil

  @@textdomain = nil

  @@country_options = { }
  @@country_options_country = nil

  @@plugins = { }
  @@methods = []
  @@formats = { }

  public

  # returns the current locale
  # checking all the priorities
  def self.locale
    self.get_locale
  end

  # returns the current textdomain
  # checking all the priorities
  def self.textdomain
    self.get_textdomain
  end

  # sets the default locale to use
  # can be overriden in the controller using set_locale
  # if not defined uses $LANG environment variable
  def self.default_locale=(lc)
    self.set_default_locale(lc)
  end

  # sets the original locale, the one
  # used in literals inside the _()
  # by default is english
  def self.original_locale=(lc)
    self.set_original_locale(lc)
  end

  # defines fallback locale in case nothing else
  # works, please do not call this function
  def self.fallback_locale=(lc)
    self.set_fallback_locale(lc)
  end

  # defines default textdomain
  # if not defined uses application name
  def self.default_textdomain=(td)
    self.set_default_textdomain(td)
  end

  # defines application name
  # if not defined uses rails app directory
  def self.app_name=(name)
    self.set_app_name(name)
  end

  # returns the current application name
  def self.app_name
    self.get_app_name
  end

  # sets application version
  # needed to generate the po files
  # by default set to 1.0.0
  def self.app_version=(version)
    self.set_app_version(version)
  end

  # returns the current application version
  def self.app_version
    self.get_app_version
  end

  # returns app_name with version
  # concadenated in a string
  def self.app_name_version
    a = []
    a << self.get_app_name if self.get_app_name
    a << self.get_app_version if self.get_app_version
    a.join(" ")
  end

  #sets the country to select by default
  def self.default_country=(country)
    self.set_default_country(country)
  end

  # sets the country to select if everything else fails
  def self.fallback_country=(country)
    self.set_fallback_country(country)
  end

  # returns the country to select if not set tries
  # to read from $LANG environment variable
  # else tries to read fallback_country
  def self.country
    self.get_country
  end

  # returns the options country hash which
  # contains currency, date order for selects, etc.
  def self.country_options
    self.get_country_options
  end
  
  # Returns an Array ready to be merged in datetime select options
  # :order => [:day, :month, :year]
  def self.date_order
    country_options[:date_select_order][:order].collect! { |element| element.to_sym }
    country_options[:date_select_order]
  end

  # sets the country
  def self.set_country(country)
    @@country = self.format_country(country)
  end

  # sets the locale
  # if locale is nil unsets
  def self.set_locale(locale)
    @@locale = self.format_locale(locale)
    GetText::set_locale(@@locale)
  end

  # defines the default methods to
  # find a locale in every controller
  # can be overriden using set_locale_by
  # as a before_filter
  # possible methods are: :header, :cookie, :session, :param
  # read GettextLocalize::Controller for
  # more info
  def self.default_methods=(ms)
    self.set_default_methods(ms)
  end

  # returns the methods assigned
  # to obtain the locale, in an array by preference
  def self.methods
    self.get_methods
  end

  # sets a datetime format to overwrite
  # the default settings
  def self.set_format(format_name,format)
    @@formats[format_name.to_sym] = format
  end

  # returns the formats
  def self.formats
    @@formats
  end

  # tries to check if the locale
  # is translated, by checking the load_paths
  # FIXME: check if Gettext has this
  def self.has_locale?(locale)
    locale = self.format_locale(locale)
    return true if locale=='C' or locale.split("_")[0] == 'en' # default locale to translate
    mos = [File.join(self.get_locale_path,locale,"LC_MESSAGES",self.get_textdomain+".mo")]
    mos << File.join(self.get_locale_path,locale.split("_")[0],"LC_MESSAGES",self.get_textdomain+".mo")
    self.each_plugin do |version,textdomain,path|
      path = self.get_locale_path(path)
      mos << File.join(path,locale,"LC_MESSAGES",textdomain+".mo")
      mos << File.join(path,locale.split("_")[0],"LC_MESSAGES",textdomain+".mo")
    end
    mos.uniq!
    mos.each do |mo|
      return true if File.file?(mo) and File.readable?(mo)
    end
    return false
  end

  # sets the default application locale paths
  # being RAILS_ROOT/locale and
  # RAILS_ROOT/vendor/plugins/$plugin/locale
  # in case the plugin has a locale dir
  def self.set_locale_paths
    require 'gettext'
    GetText::add_default_locale_path(self.get_locale_path)
    self.each_plugin do |version,name,dir|
      if File.directory?(dir) and File.readable?(dir)
        GetText::add_default_locale_path(self.get_locale_path(dir))
      end
    end
  end

  # adds a default locale path
  def self.add_default_locale_path(dir=nil)
    version = GetText::VERSION.to_s.split(".").map{|v| v.to_i }
    # if gettext 1.9.0 or greater
    if version[0] >= 1 and version[1] >= 9
      path = self.get_locale_path_with_vars(dir)
    else
      path = self.get_locale_path(dir)
    end
    GetText::add_default_locale_path(path) if path
  end

  # sets country options specified in the <code>countries.yml</code> file.
  def self.set_country_options(country=nil)
    begin
      country = self.get_country if country.nil?
      if country != @@country_options_country or !@@country_options
        countries_yml_file = Pathname.new(File.join(self.get_plugin_dir(),"countries.yml")).realpath.to_s
        countries = YAML::load(File.open(countries_yml_file))
        countries = self.string_to_sym(countries)
        if countries.has_key?(country.to_sym)
          @@country_options = countries[country.to_sym]
          @@country_options_country = country
          return true
        elsif @@country_options.nil?
          @@country_options = countries.to_a.first.last
          @@country_options_country = countries.to_a.first.first
        end
      end
    rescue
      ActiveRecord::Base.logger.error("error loading countries config #{countries_yml_file} with country #{country}: #{$!}")
    end
    false
  end

  # returns the country options updated
  def self.get_country_options
    self.set_country_options
    @@country_options
  end

  # sets the plugin textdomain and forces the creation
  # of a RAILS_ROOT/vendor/plugins/$plugin/po/$textdomain.pot
  # when executing rake gettext:plugins:updatepo
  def self.plugin_bindtextdomain(name=nil, version="1.0.0")
    if name.nil?
      name = self.get_plugin_dir_name if name.nil?
      path = self.get_plugin_locale_path if path.nil?
    else
      path = File.join(RAILS_ROOT, "vendor", "plugins", name, "locale")
    end
    self.add_plugin(name,version)
    GetText::bindtextdomain(name, :path => path)
  end

  # iterates over every application plugin that has
  # gettext localization yielding the variables
  # version, name and plugin directory
  def self.each_plugin
    Dir.glob(File.join(self.get_plugins_base_dir,"*")).each do |file|
      begin
        po_dir = Pathname.new(File.join(file,"po")).realpath.to_s
      rescue
        next
      end
      if File.directory?(po_dir) and File.writable?(po_dir)
        if defined?(@@plugins) and @@plugins[file]
          version = @@plugins[file][:version]
          name = @@plugins[file][:name]
        else
          version = "1.0.0",
          name = File.basename(file)
        end
        yield version, name, file
      end
    end
  end

  # returns a hash with the supported locales
  # in the aplication as keys and the localized
  # names of the locales as values
  def self.supported_locales
    locale_dir = File.join(RAILS_ROOT,"locale","**")
    locales = Dir.glob(locale_dir).select { |file| File.directory? file }.collect { |dir| File.basename(dir) }
    locales.collect!{|l| self.format_locale l }
    locales.each{|l| locales << l[0..1] if l.length > 2 }
    locales << @@original_locale
    self.all_locales.delete_if{|k,v| !locales.include? k.to_s }
  end

  private

  # returns all locale names, each in it's own language
  # please check the file <code>locales.yml</code> and add your own
  def self.all_locales
    locales_yml_file = Pathname.new(File.join(self.get_plugin_dir(),"locales.yml")).realpath.to_s
    locales = YAML::load(File.open(locales_yml_file))
    self.string_to_sym(locales)
  end

  # formats a given string locale in the style of
  # gettext folders es-es => es_ES
  # and adds the country if set
  def self.format_locale(locale)
    return nil if locale.nil?
    locale = locale.dup.to_s.strip if locale.respond_to?(:to_s)
    return nil if !locale.kind_of?(String) or locale.empty?
    locale = locale.split(/[^a-zA-Z.]/)[0..1].map{|p| p[0..1].downcase }
    locale << self.get_country(false) if locale.size == 1 and self.get_country(false)
    if locale.size == 2
      locale.last.gsub!(/^[a-zA-Z]{2}/){|m| m.upcase }
    end
    locale.join("_")
  end

  # formats a country
  def self.format_country(country)
    return nil if country.nil?
    country = country.dup.to_s.strip if country.respond_to?(:to_s)
    return nil if !country.kind_of?(String) or country.empty?
    return country[0..1].downcase
  end

  # sets the default locale find methods internally
  def self.set_default_methods(ms=nil)
    ms = [] if ms.nil?
    ms = [ms.to_s] unless ms.kind_of?(Array)
    @@methods = ms
  end

  # returns the locale find methods
  def self.get_methods
    if @@methods.kind_of? Array
      @@methods
    else
      []
    end
  end

  # tries to find a valid locale path
  # for a given path or RAILS_ROOT by default
  def self.get_locale_path(path=nil)
    path = RAILS_ROOT unless path
    if Pathname.new(path).relative?
      path = File.join(RAILS_ROOT, path, "locale")
    else
      path = File.join(path, "locale")
    end
    begin
      Pathname.new(path).realpath.to_s
    rescue
      nil
    end
  end

  # returns a valid locale path
  # with variables for %{locale} and %{name}
  # currently <code>get_locale_path()/%{locale}/LC_MESSAGES/%{name}.mo</code>
  def self.get_locale_path_with_vars(path=nil)
    path = self.get_locale_path(path)
    File.join(path,"%{locale}","LC_MESSAGES","%{name}.mo") if path
  end

  # sets the default locale
  def self.set_default_locale(lc)
    lc = self.format_locale(lc)
    @@default_locale = lc
    GetText::set_locale(lc)
  end

  # sets the original locale
  def self.set_original_locale(lc)
    lc = self.format_locale(lc)
    @@original_locale = lc
  end

  # sets the fallback locale
  # used in case everything else fails
  def self.set_fallback_locale(lc)
    @@fallback_locale = self.format_locale(lc)
  end

  # returns the current locale
  def self.get_locale
    [@@locale,@@default_locale,ENV['LANG'],@@fallback_locale].each do |locale|
      locale = self.format_locale(locale)
      return locale if locale
    end
    return nil
  end

  # sets the default textdomain
  # can be overriden in the controller
  def self.set_default_textdomain(td)
    @@textdomain = td
    GetText::textdomain(td)
    ActionController::Base.send(:bindtextdomain, td)
  end

  # returns the current textdomain
  def self.get_textdomain
    textdomain = @@textdomain if @@textdomain
    textdomain = self.get_app_name if textdomain.nil?
    textdomain
  end

  # sets the application name
  # used as textdomain in case no textdomain defined
  def self.set_app_name(name)
    @@app_name = name
  end

  # sets the application version
  # 1.0.0 by default
  def self.set_app_version(version)
    @@app_version = version
  end

  # returns the current application name
  # rails application dir by default
  def self.get_app_name
    if defined?(APP_NAME) and !APP_NAME.nil? and !APP_NAME.empty?
      APP_NAME.to_s
    elsif defined?(@@app_name)
      @@app_name.to_s
    else
      Pathname.new(RAILS_ROOT).realpath.basename.to_s
    end
  end

  # returns the current application version
  # 1.0.0 by default
  def self.get_app_version
    if defined?(APP_VERSION) and !APP_VERSION.nil? and !APP_VERSION.empty?
      APP_VERSION.to_s
    elsif defined?(@@app_version)
      @@app_version.to_s
    else
      "1.0.0"
    end
  end

  # sets the country
  def self.set_default_country(name)
    @@default_country = self.format_country(name)
  end

  # sets the country to fall to if everything else fails
  def self.set_fallback_country(name)
    @@fallback_country = self.format_country(name)
  end

  # returns the current country name
  # first tries to read the set locale
  # if the locale has no country
  # tries to read the set country or default
  # country, finaly tries to read the LANG
  # environment variable
  def self.get_country(use_locale=true)
    if use_locale
     options = [@@country,self.get_locale_country_part,@@default_country,
     self.get_locale_country_part(ENV['LANG']),@@fallback_country]
    else
      options = [@@country,@@default_country,@@fallback_country]
    end
    options.each do |country|
      country = self.format_country(country)
      return country if country
    end
    return nil
  end

  # returns the country part of a given locale
  def self.get_locale_country_part(locale=nil)
    begin
      locale = self.get_locale if locale.nil?
      locale = locale.split(/[^a-zA-Z_]/)[0].split("_")
      locale[1].downcase if locale[1]
    rescue
      nil
    end
  end

  # returns the current app plugin dir
  def self.get_plugins_base_dir
    Pathname.new(File.join(RAILS_ROOT,"vendor","plugins")).realpath.to_s
  end

  # returns the name of a plugin dir
  # RAILS_ROOT/vendor/plugins/gettext_localize -> gettext_localize
  # if no directory is passed it uses the current file dirname
  def self.get_plugin_dir_name(dir=nil)
    dir = File.dirname(__FILE__) if dir.nil?
    dir = Pathname.new(dir).realpath.to_s
    plugins_dir = self.get_plugins_base_dir
    if dir.starts_with?(plugins_dir)
      dir.gsub(plugins_dir,"").split("/")[1]
    end
  end

  # returns the complete absolute dir of a plugin
  def self.get_plugin_dir(dir=nil)
    name = self.get_plugin_dir_name(dir)
    if name
      Pathname.new(File.join(RAILS_ROOT,"vendor","plugins",name)).realpath.to_s
    end
  end

  # returns a plugin locale path
  def self.get_plugin_locale_path(dir=nil)
    self.get_locale_path(self.get_plugin_dir(dir))
  end

  # adds a plugin to the localized plugins list
  # a plugin is considered localized if added
  # to this list using plugin_bindtextdomain
  # or if it has a po/ directory
  def self.add_plugin(name,version="1.0.0",dir=nil)
    dir = self.get_plugin_dir if dir.nil?
    @@plugins[dir] ||= {:name=>nil,:version=>nil }
    @@plugins[dir][:name] = name
    @@plugins[dir][:version] = version
  end

  # converts string keys of a hash into symbol keys.
  def self.string_to_sym(h)
    hf = {}
    if h.is_a?(Hash)
      h.each_pair{ |key,value| value.is_a?(Hash) ? hf[key.to_sym] = self.string_to_sym(value) : hf[key.to_sym] = value }
    end
    hf
  end

end
