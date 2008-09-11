#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship and Fundraising Management for Higher Education          |
# +------------------------------------------------------------------------------------+
# | Copyright (C) 2008 Kevin Aleman, RubyCampus LLC Japan - https://rubycampus.org     |
# +------------------------------------------------------------------------------------+
# |                                                                                    |
# | This program is free software; you can redistribute it and/or modify it under the  |
# | terms of the GNU Affero General Public License version 3 as published by the Free  |
# | Software Foundation with the addition of the following permission added to Section |
# | 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED WORK IN WHICH THE     |
# | COPYRIGHT IS OWNED BY RUBYCAMPUS LLC, RUBYCAMPUS LLC DISCLAIMS THE WARRANTY OF NON |
# | INFRINGEMENT OF THIRD PARTY RIGHTS.                                                |
# |                                                                                    |
# | This program is distributed in the hope that it will be useful, but WITHOUT ANY    |
# | WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A    |
# | PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.   |
# |                                                                                    |
# | You should have received a copy of the GNU Affero General Public License along     |
# | with this program; if not, see http://www.gnu.org/licenses or write to the Free    |
# | Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  |
# | USA.                                                                               |
# |                                                                                    |
# | You can contact RubyCampus, LLC. at email address project@rubycampus.org.          |
# |                                                                                    |
# | The interactive user interfaces in modified source and object code versions of     |
# | this program must display Appropriate Legal Notices, as required under Section 5   |
# | of the GNU Affero General Public License version 3.                                |
# |                                                                                    |
# | In accordance with Section 7(b) of the GNU Affero General Public License version   |
# | 3, these Appropriate Legal Notices must retain the display of the "Powered by      |
# | RubyCampus" logo. If the display of the logo is not reasonably feasible for        |
# | technical reasons, the Appropriate Legal Notices must display the words "Powered   |
# | by RubyCampus".                                                                    |
# +------------------------------------------------------------------------------------+
#++

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # RubyCampus is packaged with all required gems and you should be able
  # to run the software with the gems provided.
  #
  # To install gems that RubyCampus depends on independantly:
  # Example: sudo rake gems:install
                                         # Gem version indicated are the minimum 
                                         # requirment and recommended for greatest
                                         # compatibility and stability.
  config.gem 'gettext',                  :version => '~> 1.92.0', 
                                         :lib => 'gettext/rails'                                
  config.gem 'haml',                     :version => '~> 2.0.2', 
                                         :lib => 'haml'  
  config.gem 'mislav-will_paginate',     :version => '~> 2.3.2', 
                                         :lib => 'will_paginate', 
                                         :source => 'http://gems.github.com'
  config.gem 'graticule',                :version => '~> 0.2.6',
                                         :source => 'http://gems.github.com'                                         
  config.gem 'active_presenter'
  config.gem 'ezcrypto',                 :version => '~> 0.7'
  config.gem 'prawn',                    :version => '~> 0.1.2',
                                         :source => 'http://gems.github.com'  

  # config.gem 'fatjam-acts_as_revisable', :version => '~> 0.9.7',
  #                                        :lib => 'acts_as_revisable', 
  #                                        :source => 'http://gems.github.com'                                          
  
  # RubyCampus presenters
  config.load_paths += %W( #{RAILS_ROOT}/app/presenters )

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.                  
  config.time_zone = 'Tokyo' # Japan Standard Time

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_rubycampus_session',
    :secret      => '9a7cafcea47a73483729b89e282db91611076afe83026fdfc467968263b800a3a04d6db38b273305a920642face221d5793846bb491de390857f0ae1e8321abf'
  }

  # RubyCampus session configuration
  config.action_controller.session_store = :active_record_store

  # RubyCampus observers
  # config.active_record.observers = :cacher, :garbage_collector
  
  # RESTful Authentication with stateful
  config.active_record.observers = :user_observer
end