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
# | You can contact RubyCampus, LLC. at email address info@rubycampus.org.             |
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

class Activity < ActiveRecord::Base
  # begin Associations
    belongs_to :activity_type 
    belongs_to :contact
    belongs_to :status   
  # end Associations
  
  # begin Validations
    validates_presence_of :activity_type_name
    validates_presence_of :contact_name
    validates_presence_of :status_name
    validates_presence_of :subject 
  # end Validations
  
  # Searchable attributes
  searchable_by :subject, :details, :location
  
  # begin Queries
    # Fetches all contacts with pagination
    def self.search_for_all_and_paginate(search, page)
      search(search).paginate( :page => page, :per_page => ROWS_PER_PAGE, :order => 'updated_at ASC' )
    end          
  # end Queries
  
  # begin Virtual Attributes 
    # begin status
      def status_name
        status.name if status
      end

      def status_name=(name)
        self.status = Status.find_by_name(name) unless name.blank?
      end          
    # end status 
  
    # begin activity_type   
      def activity_type_name
        activity_type.name if activity_type    
      end                  
  
      def activity_type_name=(name)
        self.activity_type = ActivityType.find_by_name(name) unless name.blank?  
      end  
    # end activity_type   

    # begin contact_name
      def contact_name
        contact.last_name if contact
      end                     
  
      def contact_name=(name)
        self.contact = Contact.find_by_last_name(name) unless name.blank?
      end      
    # end contact_name
  # end Virtual Attributes
end
# == Schema Information
# Schema version: 20080902230656
#
# Table name: rubycampus_activities
#
#  id               :integer(11)     not null, primary key
#  contact_id       :integer(11)
#  activity_type_id :integer(11)
#  status_id        :integer(11)
#  priority_id      :integer(11)
#  starts_at        :datetime
#  ends_at          :datetime
#  duration         :integer(11)
#  subject          :string(255)
#  details          :text
#  source_record_id :integer(11)
#  location         :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

