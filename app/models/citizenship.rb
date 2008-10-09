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

class Citizenship < ActiveRecord::Base
  # Excludes model from being included in PO template
  require 'gettext/rails'
  untranslate_all
 
      # the state of being vested with the rights, 
      # privileges, and duties of a citizen. 
   
  self.table_name = RUBYCAMPUS_CORE_COUNTRIES_TABLE
  has_many :contacts                                   
  
  NAMES_KEYS = self.find(:all, :conditions => "is_enabled = true and is_citizenship = true", :order => "position ASC, id ASC").map do |s| 
  [s.name, s.id] 
  end
end


# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_countries
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)     not null
#  iso_code            :string(255)
#  country_code        :string(255)
#  idd_prefix          :string(255)
#  ndd_prefix          :string(255)
#  region_id           :integer(4)
#  is_nationality      :boolean(1)      default(TRUE)
#  is_country_of_birth :boolean(1)      default(TRUE)
#  is_citizenship      :boolean(1)      default(TRUE)
#  is_default          :boolean(1)
#  is_reserved         :boolean(1)      default(TRUE)
#  is_enabled          :boolean(1)      default(TRUE)
#  position            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

