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

class Group < ActiveRecord::Base

  # start Associations
    belongs_to :group_type

    has_and_belongs_to_many :contacts
  # end Associations

  # begin Validations
    validates_presence_of :name
    validates_presence_of :description
    validates_presence_of :group_type_id
  # ends Validations

  # Searchable attributes
  searchable_by :name

  # Fetches all groups with pagination
  def self.search_for_all_and_paginate(locate, page)
    search(locate).paginate( :page => page, :per_page => AppConfig.rows_per_page, :order => 'updated_at ASC' )
  end

  # Lists qualifying model attributes for use by auto completion in forms
  def self.find_for_auto_complete_lookup(search)
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"], :order => "name ASC" )
  end

end

# == Schema Information
# Schema version: 20081015011538
#
# Table name: rubycampus_groups
#
#  id              :integer(4)      not null, primary key
#  domain_id       :integer(4)      default(1), not null
#  name            :string(255)     not null
#  title           :string(255)
#  description     :string(255)
#  saved_search_id :integer(4)
#  where_clause    :text
#  select_tables   :text
#  where_tables    :text
#  group_type_id   :integer(4)      not null
#  is_enabled      :boolean(1)      default(TRUE)
#  is_reserved     :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

