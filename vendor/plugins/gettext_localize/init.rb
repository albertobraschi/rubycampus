

# Ruby unicode support
$KCODE = 'u'
require 'jcode'

# require gettext for ruby
begin
  gem 'gettext', '>= 1.9'
  require 'gettext/rails'
  require 'gettext/utils'
rescue
  raise StandardError.new("gettext could not be loaded: #{$!}")
end

# global methods
# all in the GettextLocalize module
require 'gettext_localize'

# locale used in the literals to be translated
GettextLocalize::original_locale = 'en'
# locale in case everything else fails
GettextLocalize::fallback_locale = 'en'
# country if everything else fails
GettextLocalize::fallback_country = 'us'

# add this plugin as a new textdomain
# add this line to every localized plugin
GettextLocalize::plugin_bindtextdomain

# initialize country options from YML file
GettextLocalize::set_country_options

# base ruby class extensions
require 'gettext_localize_extend'
# rubyo on rails class extensions
require 'gettext_localize_rails'

# set paths with LC_MESSAGES
GettextLocalize::set_locale_paths

ActionView::Base.send(:include, GettextLocalize::Helper)
ActionController::Base.send(:include, GettextLocalize::Controller)
class ActionController::Base
  before_filter{|c| c.set_default_gettext_locale }
end
