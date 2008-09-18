module GettextLocalize

  # returns the abbreviated daynames in current locale
  # starting mith sunday!
  def self.abbr_daynames
     [_("Sun"),_("Mon"),_("Tue"),_("Wed"),_("Thu"),_("Fri"),_("Sat")]
  end

  # returns the daynames in current locale
  # starting mith sunday!
  def self.daynames
    [_("Sunday"),_("Monday"),_("Tuesday"),_("Wednesday"),_("Thursday"),_("Friday"),_("Saturday")]
  end

  # returns the abbreviated monthnames in current locale
  # starting with a nil value, then january
  def self.abbr_monthnames
    [nil,_("Jan"),_("Feb"),_("Mar"),_("Apr"),s_("Abbr|May"),_("Jun"),
     _("Jul"),_("Aug"),_("Sep"),_("Oct"),_("Nov"),_("Dec")]
  end

  # returns the monthnames in current locale
  # starting with a nil value, then january
  def self.monthnames
    [nil,_("January"),_("February"),_("March"),_("April"),_("May"),_("June"),
     _("July"),_("August"),_("September"),_("October"),_("November"),_("December")]
  end

  # returns the monthnames in current locale
  # in format "5 of January", localized apart to correctly
  # translate month diferences in other locales
  # use %V to get this in strftime
  # starting with a nil value, then january
  def self.of_monthnames
    [nil,_("%s of January"),_("%s of February"),_("%s of March"),_("%s of April"),_("%s of May"),_("%s of June"),
     _("%s of July"),_("%s of August"),_("%s of September"),_("%s of October"),_("%s of November"),_("%s of December")]
  end

  def self.to_sentence_text_connector
    _("and")
  end

  # localized time functions
  # don't like to overwrite Date::MONTHNAMES and such because
  # they are constants and aren't localized each time the constant
  # is read so if the locale changed in the meantime they aren't updated
  module TimeMethods

    # overwrites strftime to localize options
    # that return strings
    # adds format %V - returns "of %B" localized, for example in catalan
    # "de Gener" = "of January" and "d'Abril" = "of April"
    def strftime_locale(format=nil,disable_locale=false)
      return if format.nil?
      format = format.dup
      unless disable_locale
        format.gsub!("%V", GettextLocalize::of_monthnames[self.mon] % '%e' )
        format.gsub!("%v", GettextLocalize::of_monthnames[self.mon] % '%d' )
        format.gsub!("%a", GettextLocalize::abbr_daynames[self.wday])
        format.gsub!("%A", GettextLocalize::daynames[self.wday])
        format.gsub!("%b", GettextLocalize::abbr_monthnames[self.mon])
        format.gsub!("%B", GettextLocalize::monthnames[self.mon])
      end
      strftime_nolocale(format)
    end

    # tries to read the DATE_FORMATS hash
    # or returns empty hash
    def date_formats(disable_locale=false)
      formats = self.class::DATE_FORMATS
      formats = formats.dup if formats.respond_to? :dup
      formats = {} unless formats.kind_of? Hash
      if disable_locale and respond_to?(:not_localized_formats) and not_localized_formats.kind_of?(Hash)
        formats.merge! not_localized_formats
      elsif respond_to?(:localized_formats) and localized_formats.kind_of?(Hash)
        formats.merge! localized_formats
      end
      if GettextLocalize::formats.kind_of?(Hash)
        formats.merge! GettextLocalize::formats
      end
      formats
    end

    # overwrites to_s to localize strftime
    # on db we use the non localized version
    def to_s_locale(format_name=:default,disable_locale=false)
      if format_name == :db
        disable_locale = true
      end
      if !disable_locale and !localized_format?(format_name)
        disable_locale = true
      end
      unless date_formats(disable_locale).has_key?(format_name)
        format = :default
      end
      format = date_formats(disable_locale)[format_name]
      strftime_locale(format,disable_locale)
    end

    # returns if a format is localized or fixed
    def localized_format?(format_name)
      (
       !( not_localized_formats.respond_to?(:has_key?) and not_localized_formats.has_key?(format_name) ) or
       ( localized_formats.respond_to?(:has_key?) and localized_formats.has_key?(format_name) )
      )
    end

  end
end

# now overwrite the date and time classes
class Date
  def not_localized_formats
    { :default => "%Y-%m-%d",
      :db => "%Y-%m-%d",
    }
  end
  def localized_formats
    { :default => s_("date|default|%Y-%m-%d"),
      :short => s_("date|short|%e %b"),
      :long => s_("date|long|%B %e, %Y"),
    }
  end
  include GettextLocalize::TimeMethods
  alias :to_s_nolocale :to_s
  alias :to_s :to_s_locale
  alias :strftime_nolocale :strftime
  alias :strftime :strftime_locale
end

class Time
  def not_localized_formats
    { :default => "%a %b %d %H:%M:%S %Z %Y",
      :db => "%Y-%m-%d %H:%M:%S",
      :rfc822 => "%a, %d %b %Y %H:%M:%S %z",
    }
  end
  def localized_formats
    { :default => s_("time|default|%a %b %d %H:%M:%S %Z %Y"),
      :short => s_("time|short|%d %b %H:%M"),
      :long => s_("time|long|%B %d, %Y %H:%M"),
    }
  end
  include GettextLocalize::TimeMethods
  alias :to_s_nolocale :to_s
  alias :to_s :to_s_locale
  alias :strftime_nolocale :strftime
  alias :strftime :strftime_locale
end

class DateTime
  def not_localized_formats
    { :default => "%a %b %d %H:%M:%S %Y",
      :db => "%Y-%m-%d %H:%M:%S",
    }
  end
  def localized_formats
    { :default => s_("datetime|default|%a %b %d %H:%M:%S %Y"),
      :short => s_("datetime|short|%e %b"),
      :long => s_("datetime|long|%B %e, %Y"),
    }
  end
  include GettextLocalize::TimeMethods
  alias :to_s_nolocale :to_s
  alias :to_s :to_s_locale
end

