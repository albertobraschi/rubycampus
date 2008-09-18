
module GettextLocalize

  RAILS_MAJOR, RAILS_MINOR, RAILS_TINY = RAILS_GEM_VERSION.split(".").map(&:to_i)

  module Helper
  end

  # == ActionController extensions
  # extends controller to by default
  # set locale and overwrite using before_filters
  module Controller

    # loads default gettext in every controller
    # can be overriden in a controller by
    # calling init_gettext
    def init_default_gettext(textdomain=nil)
      textdomain = GettextLocalize::textdomain if textdomain.nil?
      unless textdomain.nil?
        ActionController::Base::init_gettext(textdomain)
        true
      end
    end

    # loads default locale in every controller
    # can be overriden by calling set_locale
    def set_default_locale(locale=nil)
      #locale = GettextLocalize::locale if ( locale.nil? || locale == 'en-us' ) # FIXME: Hack for Rails 2.0
      locale = GettextLocalize::locale if locale.nil?
      unless locale.nil?
        GettextLocalize::set_locale(locale)
        true
      end
    end

    # sets locale unless nil or empty
    def set_locale_if(locale=nil)
      locale = locale.respond_to?(:to_s) ? locale.to_s : ""
      set_default_locale locale unless locale.strip.empty?
    end

    # binds default textdomain in every controller
    # can be overriden by calling bindtextdomain
    def bind_default_textdomain(textdomain=nil)
      textdomain = GettextLocalize::textdomain if textdomain.nil?
      textdomain = ActionController::Base.textdomainname if textdomain.nil?
      unless textdomain.nil?
        GetText::bindtextdomain(textdomain,:path=>GettextLocalize::get_locale_path)
        true
      end
    end

    # sets a controllers country
    # by default uses GettextLocalize::default_country
    def set_country(country)
      unless country.nil?
        GettextLocalize::set_country(country)
        true
      end
    end
    alias :set_default_country :set_country

    # by default sets locale, textdomain and gettext in all controllers
    # forces default locale if nothing found, not set when executing
    # set_locale_by directly
    def set_default_gettext_locale(locale=nil,textdomain=nil,methods=nil)
      methods = GettextLocalize::methods if methods.nil?
      methods << :default
      set_locale_by(*methods)
      bind_default_textdomain(textdomain)
      init_default_gettext(textdomain)
    end

    # sets controllers locale by the methods specified
    # tries them in order till one works
    # available methods = :header, :cookie, :session, :param
    # example use in controller class, calling before_filter with params:
    # <tt>before_filter(:except=>"feed"){|c| c.set_locale_by :param, :session, :header }</tt>
    def set_locale_by(*methods)
      params = []
      if methods.first.kind_of? Array
        params = methods[1..-1]
        methods = methods.first
      end
      methods << :default
      methods.each do |method|
        func = "set_locale_by_#{method}".to_sym
        if respond_to?(func)
          return true if self.send(func,*params) == true
        end
      end
    end

    # sets the controllers locale by the user header
    # tries to find the language localizations starting
    # from the best language
    # example header:
    # <tt>HTTP_ACCEPT_LANGUAGE = es-es,es;q=0.8,en-us;q=0.5,en;q=0.3</tt>
    # add to your controller:
    # <tt>before_filter :set_locale_by_header</tt>
    def set_locale_by_header(name='lang')
      name = 'HTTP_ACCEPT_LANGUAGE'
      GettextLocalize::set_locale(nil)
      locales = self.get_locales_from_hash(request.env,name)
      return unless locales
      locales.each do |locale|
        if GettextLocalize.has_locale?(locale)
          return set_default_locale(locale)
        end
      end
    end

    # sets the controllers locale by the content of a cookie
    # by default takes the cookie named 'lang'
    # tries to find the language localizations starting from
    # the first language specified, separated by commas, example
    # <tt> cookies['lang'] = 'es-es,es,en,en-us'</tt>
    # add to your controller:
    # <tt>before_filter :set_locale_by_cookie</tt>
    def set_locale_by_cookie(name="lang")
      GettextLocalize::set_locale(nil)
      locales = self.get_locales_from_hash(cookies,name)
      return unless locales
      locales.each do |locale|
        if GettextLocalize.has_locale?(locale)
          return set_default_locale(locale)
        end
      end
    end

    # sets the controllers locale by the content of a cookie
    # by default takes the cookie named 'lang'
    # tries to find the language localizations starting from
    # the first language specified, separated by commas, example
    # <tt> session['lang'] = 'es,fr'</tt>
    # add to your controller:
    # <tt>before_filter :set_locale_by_session</tt>
    # remember this only saves the session lang if
    # use session is activated
    def set_locale_by_session(name='lang')
      GettextLocalize::set_locale(nil)
      locales = self.get_locales_from_hash(session,name)
      return unless locales
      locales.each do |locale|
        # has_locale? checks if locale file exists
        # FIXME: could return false if locale file
        # outside of the application
        if GettextLocalize.has_locale?(locale)
          return set_default_locale(locale)
        end
      end
    end

    # sets the controllers locale by the value of a param
    # passed by GET or POST, by default named 'lang'
    # with values of locales separated by commas,
    # tries to find them in order, for example calling
    # the url <tt>http://localhost:3000/?lang=es</tt>
    # and in the controller:
    # <tt>before_filter :set_locale_by_param</tt>
    def set_locale_by_param(name='lang')
      GettextLocalize::set_locale(nil)
      locales = self.get_locales_from_hash(params,name)
      return unless locales
      locales.each do |locale|
        if GettextLocalize.has_locale?(locale)
          return set_default_locale(locale)
        end
      end
    end

    # sets the default locale
    # used to define <tt>set_locale_by :param, :default</tt>
    def set_locale_by_default(name='lang')
      set_default_locale
    end

    protected

    # reads a locales parameter from a hash
    # accepts header format with priorities (see set_locale_by_header)
    # and a list of locales separated by commas
    def get_locales_from_hash(hash,name='lang')
      name = name.to_sym if hash[name.to_sym]
      name = name.to_s if hash[name].respond_to?(:empty?) and hash[name].empty?
      return unless hash[name]
      value = hash[name].dup
      return unless value.respond_to?(:to_s)
      value = value.to_s.strip
      return if value.empty?

      if value.include?("q=") # format with priorities
        locales = {}
        value.scan(/([^;]+);q=([^,]+),?/).each do |langs,priority|
          locales[priority.to_f] = langs.split(",")
        end
        locales = locales.sort.reverse.map{|p| p.last }.flatten
      else # format separated commas
        locales = []
        locales = value.split(",")
      end
      return locales
    end

  end
end

# ActiveRecord extensions
# overwrite to force Date quote
module ActiveRecord
  module ConnectionAdapters
    module Quoting
      alias :quote_orig :quote
      def quote(value, column = nil)
        if value.kind_of?(Date)
          value = value.dup.strftime("%Y-%m-%d")
        end
        quote_orig(value,column)
      end
    end
  end
end

# ActionView extensions
module ActionView

  # FIXME: Temporary Hack to make gettext work with rails 2.1
  # See: http://zargony.com/2008/02/12/edge-rails-and-gettext-undefined-method-file_exists-nomethoderror
  if (GettextLocalize::RAILS_MAJOR >= 2 && GettextLocalize::RAILS_MINOR >= 1)
    class Base
      delegate :file_exists?, :to => :finder unless respond_to?(:file_exists?)
    end
  end

   module Helpers
    # DateHelper extensions
    module DateHelper

      def with_rails_version_call(method_name, *args)
        if (GettextLocalize::RAILS_MAJOR >= 2 && GettextLocalize::RAILS_MINOR >= 1)
          send(method_name, *args)
        else
          send(method_name, *args[0..-2])
        end
      end

      alias_method :orig_date_select, :date_select

      # modify date_select to insert date order specified on
      # countries.yml file.
      def date_select(object_name, method, options = {}, html_options = {})
        options.reverse_merge!(GettextLocalize::date_order) unless options.include? :order
        with_rails_version_call(:orig_date_select, object_name, method, options, html_options)  #:order => [:day,:month,:year])# options)
      end

      alias_method :orig_select_date, :select_date

      # modify select_date to apply order specified on
      # countries.yml file.
      def select_date(date = Date.today, options = {}, html_options = {})
        options.reverse_merge!(GettextLocalize::date_order) unless options.include? :order
        with_rails_version_call(:orig_select_date, date, options, html_options)
      end

      alias_method :orig_datetime_select, :datetime_select

      # modify datetime_select to insert date order specified on
      # countries.yml file.
      def datetime_select(object_name, method, options = {}, html_options = {})
        if GettextLocalize::date_order.respond_to? :merge
          options.reverse_merge!(GettextLocalize::date_order) unless options.include? :order
        end
        with_rails_version_call(:orig_datetime_select, object_name, method, options, html_options)
      end

      alias_method :orig_select_datetime, :select_datetime

      # modify select_datetime to apply order specified on
      # countries.yml file.
      def select_datetime(datetime = Time.now, options = {}, html_options = {})
        options.reverse_merge!(GettextLocalize::date_order) unless options.include? :order
        with_rails_version_call(:orig_select_datetime, datetime, options, html_options)
      end

      alias :select_month_nolocale :select_month

      def select_month(date, options = {}, html_options = {})
        options[:use_month_names] = (options[:use_short_month] ? GettextLocalize::abbr_monthnames : GettextLocalize::monthnames) unless options[:use_month_names]
        with_rails_version_call(:select_month_nolocale, date, options, html_options)
      end

    end
    
    class InstanceTag
      alias_method :orig_to_datetime_select_tag , :to_datetime_select_tag
    
      def to_datetime_select_tag(options = {}, html_options = {})
        options.reverse_merge!(GettextLocalize::date_order) unless options.include? :order
        with_rails_version_call(:orig_to_datetime_select_tag, options, html_options)
      end
    end

    # NumberHelper extensions
    module NumberHelper
      alias_method :orig_number_to_currency, :number_to_currency

      # modify number_to_currency to load currency options specified on
      # country.yml file.
      def number_to_currency(number, options = {})
        country_options = GettextLocalize::country_options
        options.reverse_merge!(country_options[:currency])
        options[:order] ||= ["unit", "number"]
        options = options.stringify_keys
        precision, unit, separator, delimiter = options.delete("precision") { 2 }, options.delete("unit") { "$" }, options.delete("separator") { "." }, options.delete("delimiter") { "," }
        separator = "" unless precision > 0

        unit = " " + unit if options["order"] == ["number", "unit"]
        output = ''
        begin
          options["order"].each do |param|
            case param.to_s
              when "unit"
                output << unit
              when "number"
                parts = number_with_precision(number, precision).split('.')
                output << number_with_delimiter(parts[0], delimiter) + separator + parts[1].to_s
            end
          end
        rescue
          output = number
        end
        output
      end
    end
  end
end


class Array
  alias :orig_to_sentence :to_sentence

  # modify to_sentence to translate connector.
  def to_sentence(options = {})
    options.reverse_merge!({:connector => GettextLocalize::to_sentence_text_connector})
    orig_to_sentence(options)
  end
end


