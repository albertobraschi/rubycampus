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

class Address < ActiveRecord::Base
  # Excludes model from being included in PO template
  require 'gettext/rails'
  untranslate_all
 
  belongs_to :contact
  belongs_to :location_type
  
  belongs_to :country
  belongs_to :region
  
  acts_as_revisable do
    revision_class_name "AddressRevision"
  end 
  
  # Validations
  validates_as_rubycampus_street_address :line_1, :line_2  

#:stopdoc:  
  # Virtual Attributes  
  def country_name
    country.name if country    
  end                  
  
  def country_name=(name)
    self.country = Country.find_by_name(name) unless name.blank?  
  end  
  
  def region_name
    region.name if region    
  end                  
  
  def region_name=(name)
    self.region = Region.find_by_name(name) unless name.blank?  
  end
#:startdoc:      
end
class AddressRevision < ActiveRecord::Base
  acts_as_revision :revisable_class_name => "Address"
end

# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_addresses
#
#  id                         :integer(4)      not null, primary key
#  contact_id                 :integer(4)
#  location_type_id           :integer(4)
#  is_primary                 :boolean(1)
#  is_billing                 :boolean(1)
#  line_1                     :string(255)
#  line_2                     :string(255)
#  locality                   :string(255)
#  region_id                  :integer(4)
#  postal_code                :string(255)
#  country_id                 :integer(4)
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

