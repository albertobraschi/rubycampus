#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Student & Alumni Relationship Management Software                     |
# +------------------------------------------------------------------------------------+
# | Copyright © 2008-2009 Kevin R. Aleman. Fukuoka, Japan. All Rights Reserved.        |
# +------------------------------------------------------------------------------------+
# |                                                                                    |
# | This program is free software; you can redistribute it and/or modify it under the  |
# | terms of the GNU Affero General Public License version 3 as published by the Free  |
# | Software Foundation with the addition of the following permission added to Section |
# | 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED WORK IN WHICH THE     |
# | COPYRIGHT IS OWNED BY KEVIN R ALEMAN, KEVIN R ALEMAN DISCLAIMS THE WARRANTY OF NON |
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
# | You can contact the author Kevin R. Aleman by email at KALEMAN@RUBYCAMPUS.ORG. The |
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
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # RubyCampus is binded to the following gems and versions
  config.gem 'haml', :version => '2.0.6', :lib => 'haml'
  config.gem 'rspec-rails', :version => '1.1.12', :lib => 'spec/rails'
  config.gem 'mislav-will_paginate', :version => '2.3.6', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'graticule', :version => '0.2.8'
  config.gem 'ezcrypto', :version => '0.7'
  config.gem 'prawn', :version => '0.4.0'
  config.gem 'json', :version => '1.1.3'
  config.gem 'fatjam-acts_as_revisable', :version => '0.9.7', :lib => 'acts_as_revisable', :source => 'http://gems.github.com'
  config.gem 'active_presenter', :version => '0.0.6'

  # Central Authentication Service (CAS)
  config.gem 'rubycas-client',           :version => '2.0.1'

  # RubyCampus presenters
  config.load_paths += %W( #{RAILS_ROOT}/app/presenters )

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

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