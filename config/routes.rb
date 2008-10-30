#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Student & Alumni Relationship Management Software                     |
# +------------------------------------------------------------------------------------+
# | Copyright (C) 2008 Kevin Aleman, RubyCampus LLC - https://rubycampus.org           |
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

ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => "dashboard"
  map.root :controller => "sessions", :action => "destroy"

  # begin RubyCampus Administration
  map.resources :administers
  map.resources :announcements, :collection => { :index => :get}
  # end RubyCampus Administration

  # begin RubyCampus Processors
  map.resources :activities, :collection => { :index => :get}
  # end RubyCampus Processors

  # begin RubyCampus Constituents
  map.resources :contacts, :collection => { :lookup => :get }
  map.resources :individuals, :collection => { :index => :get }
  map.resources :organizations, :collection => { :index => :get }
  map.resources :households, :collection => { :index => :get }
  # end RubyCampus Constituents

  # begin RubyCampus Mailings
  map.resources :mailing_mixins, :collection => { :lookup => :get, :index => :get },
                                 :member => { :enable => :put, :disable => :put }
  map.resources :mailing_mixin_types, :collection => { :lookup => :get, :index => :get }
  # end RubyCampus Mailings

  # begin RubyCampus RESTful Code Tables
  map.resources :academic_levels, :collection => { :lookup => :get, :index => :get }
  map.resources :activity_types, :collection => { :lookup => :get, :index => :get }
  map.resources :countries, :collection => { :lookup => :get }
  map.resources :education_levels, :collection => { :lookup => :get, :index => :get }
  map.resources :entry_terms, :collection => { :lookup => :get, :index => :get }
  map.resources :ethnicities, :collection => { :lookup => :get, :index => :get }
  map.resources :genders, :collection => { :lookup => :get, :index => :get }
  map.resources :greetings, :collection => { :lookup => :get, :index => :get }
  map.resources :groups, :collection => { :lookup => :get, :index => :get },
                         :member => { :enable => :put, :disable => :put, :members => :get }
  map.resources :head_of_households, :collection => { :lookup => :get }
  map.resources :location_types, :collection => { :lookup => :get, :index => :get }
  map.resources :marital_statuses, :collection => { :lookup => :get, :index => :get }
  map.resources :message_templates, :collection => { :lookup => :get, :index => :get }
  map.resources :messaging_providers, :collection => { :lookup => :get, :index => :get }
  map.resources :mobile_providers, :collection => { :lookup => :get, :index => :get }
  map.resources :name_prefixes, :collection => { :lookup => :get, :index => :get }
  map.resources :name_suffixes, :collection => { :lookup => :get, :index => :get }
  map.resources :phone_types, :collection => { :lookup => :get, :index => :get }
  map.resources :programs, :collection => { :lookup => :get, :index => :get }
  map.resources :regions, :collection => { :lookup => :get }
  map.resources :sources, :collection => { :lookup => :get, :index => :get }
  map.resources :stages, :collection => { :lookup => :get, :index => :get }
  map.resources :statuses, :collection => { :lookup => :get, :index => :get }
  # end RubyCampus RESTful Code Tables

  # begin RESTful_authentication routes
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:id', :controller => 'user_accounts', :action => 'show'
  map.change_password '/change_password',   :controller => 'user_accounts', :action => 'edit'
  map.forgot_password '/forgot_password',   :controller => 'passwords', :action => 'new'
  map.reset_password '/reset_password/:id', :controller => 'passwords', :action => 'edit'
  map.resources :users, :collection => { :index => :get }, :member => { :enable => :put } do |users|
    users.resource  :user_account
    users.resources :roles
  end
  map.resource :session
  map.resource :password
  # end RESTful_authentication routes

  # start Static routes
  map.with_options :controller => 'static' do |static|
    static.about 'about', :action => 'about'
    static.license 'license', :action => 'license'
  end
  # end Static routes

  # begin RESTful_ACL routes
  map.error '/error', :controller => 'sessions', :action => 'error'
  map.denied '/denied', :controller => 'sessions', :action => 'denied'
  # end RESTful_ACL routes

  # begin RAILS default routes
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  # end RAILS default routes
end
