#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship Management & Alumni Development Software                 |
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

class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer    :domain_id, :default => 1, :null => false  # TODO Remove default      
      t.integer    :academic_level_id
      t.integer    :citizenship_id
      t.integer    :contact_type_id
      t.integer    :country_of_birth_id
      t.integer    :education_level_id
      t.integer    :entry_term_id
      t.integer    :ethnicity_id
      t.integer    :gender_id
      t.integer    :greeting_id
      t.integer    :marital_status_id
      t.integer    :moodle_user_id
      t.integer    :name_prefix_id
      t.integer    :name_suffix_id
      t.integer    :nationality_id
      t.integer    :preferred_communication_method_id
      t.integer    :preferred_email_format_id
      t.integer    :program_id        
      t.integer    :source_id
      t.integer    :stage_id
      t.boolean    :do_not_email
      t.boolean    :do_not_phone
      t.boolean    :do_not_mail
      t.boolean    :do_not_trade
      t.boolean    :is_opt_out
      t.string     :legal_identifier
      t.string     :external_identifier
      t.string     :nick_name
      t.string     :legal_name
      t.string     :homepage_url
      t.string     :image_url
      t.string     :last_name
      t.string     :first_name
      t.string     :middle_name
      t.string     :phonetic_last_name
      t.string     :phonetic_first_name
      t.string     :phonetic_middle_name
      t.string     :job_title
      t.date       :deceased_date
      t.integer    :mail_to_household_id
      t.string     :household_name
      t.integer    :head_of_household_id
      t.string     :organization_name
      t.string     :sic_code
      t.integer    :user_id
      t.integer    :assigned_to_user_id
      t.integer    :lock_version,                     :default => 0
      t.date       :date_of_birth
      t.binary     :government_identification_number
      t.boolean    :is_foreign
      t.boolean    :is_deceased
      t.datetime   :created_at
      t.datetime   :updated_at
      t.integer    :last_modified_by_user_id
      
      t.integer    :asset_id      
    end
  end

  def self.down
    drop_table :contacts
  end
end
