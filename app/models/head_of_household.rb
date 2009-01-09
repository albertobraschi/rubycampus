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

class HeadOfHousehold < ActiveRecord::Base

  self.table_name = RUBYCAMPUS_HEAD_OF_HOUSEHOLD_TABLE
  has_many :contacts     
    
end


# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_contacts
#
#  id                                :integer(4)      not null, primary key
#  domain_id                         :integer(4)      default(1), not null
#  academic_level_id                 :integer(4)
#  citizenship_id                    :integer(4)
#  contact_type_id                   :integer(4)
#  country_of_birth_id               :integer(4)
#  education_level_id                :integer(4)
#  entry_term_id                     :integer(4)
#  ethnicity_id                      :integer(4)
#  gender_id                         :integer(4)
#  greeting_id                       :integer(4)
#  marital_status_id                 :integer(4)
#  moodle_user_id                    :integer(4)
#  name_prefix_id                    :integer(4)
#  name_suffix_id                    :integer(4)
#  nationality_id                    :integer(4)
#  preferred_communication_method_id :integer(4)
#  preferred_email_format_id         :integer(4)
#  program_id                        :integer(4)
#  source_id                         :integer(4)
#  stage_id                          :integer(4)
#  do_not_email                      :boolean(1)
#  do_not_phone                      :boolean(1)
#  do_not_mail                       :boolean(1)
#  do_not_trade                      :boolean(1)
#  is_opt_out                        :boolean(1)
#  legal_identifier                  :string(255)
#  external_identifier               :string(255)
#  nick_name                         :string(255)
#  legal_name                        :string(255)
#  homepage_url                      :string(255)
#  image_url                         :string(255)
#  last_name                         :string(255)
#  first_name                        :string(255)
#  middle_name                       :string(255)
#  phonetic_last_name                :string(255)
#  phonetic_first_name               :string(255)
#  phonetic_middle_name              :string(255)
#  job_title                         :string(255)
#  deceased_date                     :date
#  mail_to_household_id              :integer(4)
#  household_name                    :string(255)
#  head_of_household_id              :integer(4)
#  organization_name                 :string(255)
#  sic_code                          :string(255)
#  user_id                           :integer(4)
#  assigned_to_user_id               :integer(4)
#  lock_version                      :integer(4)      default(0)
#  date_of_birth                     :date
#  government_identification_number  :binary
#  time_zone                         :string(255)
#  language                          :string(5)       default("en"), not null
#  is_foreign                        :boolean(1)
#  is_deceased                       :boolean(1)
#  last_modified_by_user_id          :integer(4)
#  asset_id                          :integer(4)
#  revisable_original_id             :integer(4)
#  revisable_branched_from_id        :integer(4)
#  revisable_number                  :integer(4)
#  revisable_name                    :string(255)
#  revisable_type                    :string(255)
#  revisable_current_at              :datetime
#  revisable_revised_at              :datetime
#  revisable_deleted_at              :datetime
#  revisable_is_current              :boolean(1)
#  created_at                        :datetime
#  updated_at                        :datetime
#

