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

class Address < ActiveRecord::Base 
  belongs_to :contact
  belongs_to :location_type
  
  belongs_to :country
  belongs_to :region 
  
  # Validations
  validates_as_rubycampus_street_address :line_1, :line_2  
  
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
      
end
# == Schema Information
# Schema version: 20080902230656
#
# Table name: rubycampus_addresses
#
#  id               :integer(11)     not null, primary key
#  contact_id       :integer(11)
#  location_type_id :integer(11)
#  is_primary       :boolean(1)
#  is_billing       :boolean(1)
#  line_1           :string(255)
#  line_2           :string(255)
#  locality         :string(255)
#  region_id        :integer(11)
#  postal_code      :string(255)
#  country_id       :integer(11)
#  created_at       :datetime
#  updated_at       :datetime
#

