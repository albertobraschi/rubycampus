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

class Activity < ActiveRecord::Base

  # begin Associations
    belongs_to :activity_type 
    belongs_to :contact
    belongs_to :status   
  # end Associations
  
  acts_as_revisable do
    revision_class_name "ActivityRevision"
  end
  
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
      search(search).paginate( :page => page, :per_page => AppConfig.rows_per_page, :order => 'updated_at ASC' )
    end          
  # end Queries
#:stopdoc:  
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
#:startdoc:
end
class ActivityRevision < ActiveRecord::Base
  acts_as_revision :revisable_class_name => "Activity"
end


# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_activities
#
#  id                         :integer(4)      not null, primary key
#  contact_id                 :integer(4)      not null
#  activity_type_id           :integer(4)
#  status_id                  :integer(4)
#  priority_id                :integer(4)
#  subject                    :string(255)
#  details                    :text
#  location                   :string(255)
#  starts_at                  :datetime
#  ends_at                    :datetime
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

