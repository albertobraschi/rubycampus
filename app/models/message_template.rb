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

class MessageTemplate < ActiveRecord::Base 
  # Excludes model from being included in PO template
  require 'gettext/rails'
  untranslate_all

  # begin Validations
    validates_presence_of :name
    validates_presence_of :subject
    validates_presence_of :text
    
    validates_uniqueness_of :name
  # ends Validations
  
  acts_as_revisable do
    revision_class_name "Session"
  end
  
  # Searchable attributes
  searchable_by :name
  
  # Fetches all message_templates with pagination
  def self.search_for_all_and_paginate(locate, page)
    search(locate).paginate( :page => page, :per_page => AppConfig.rows_per_page, :order => 'updated_at ASC' )
  end         
  
  # Lists qualifying model attributes for use by auto completion in forms
  def self.find_for_auto_complete_lookup(search)
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"], :order => "name ASC" )  
  end

end


# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_message_templates
#
#  id                         :integer(4)      not null, primary key
#  domain_id                  :integer(4)      default(1), not null
#  name                       :string(255)     not null
#  subject                    :string(255)     not null
#  html                       :text
#  text                       :text            not null
#  is_enabled                 :boolean(1)      default(TRUE)
#  revisable_original_id      :integer(4)
#  revisable_branched_from_id :integer(4)
#  revisable_number           :integer(4)
#  revisable_name             :string(255)
#  revisable_type             :string(255)
#  revisable_current_at       :datetime
#  revisable_revised_at       :datetime
#  revisable_deleted_at       :datetime
#  revisable_is_current       :boolean(1)
#  created_at                 :datetime
#  updated_at                 :datetime
#

