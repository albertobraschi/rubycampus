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

# Generates Simulated Constituent Information for Development and Demo

# Required gems:
# sudo gem install populator faker echoe

namespace :db do
  desc "Erase and fill database"
  task :demo => :environment do
    require 'populator'
    require 'faker'

    [Contact, Address, Phone, Email, Messenger].each(&:delete_all)

    Contact.populate 200 do |contact|
      contact.contact_type_id           = [1,2,3]
      contact.domain_id                 = 1
      contact.stage_id                  = [100,200,250,300,350,400,500,999] if contact.contact_type_id == 1
      contact.entry_term_id             = [1,2] if contact.contact_type_id == 1
      contact.preferred_communication_method_id = [1,2,3,4,5]
      contact.preferred_email_format_id = [1,2,3]
      contact.source_id                 = [1,2,3,4,5,6,7,8,9,10,11]
      contact.name_prefix_id            = [1,2,3,4] if contact.contact_type_id == 1
      contact.name_suffix_id            = [1,2,3,4] if contact.contact_type_id == 1
      contact.marital_status_id         = [1,2,3,4,5,6] if contact.contact_type_id == 1
      contact.citizenship_id            = Country.find_by_name("United States") if contact.contact_type_id == 1
      contact.nationality_id            = Country.find_by_name("United States") if contact.contact_type_id == 1
      contact.ethnicity_id              = [1,2,3,4,5,6] if contact.contact_type_id == 1
      contact.education_level_id        = [1,2,3,4,5,6,7] if contact.contact_type_id == 1
      contact.academic_level_id         = [1,2,3,4,5] if contact.contact_type_id == 1
      contact.gender_id                 = [1,2] if contact.contact_type_id == 1
      contact.country_of_birth_id       = Country.find_by_name("United States") if contact.contact_type_id == 1
      contact.greeting_id               = [1,2,3,4] if contact.contact_type_id == 1
      contact.do_not_email              = [true,false]
      contact.do_not_phone              = [true,false]
      contact.do_not_mail               = [true,false]
      contact.do_not_trade              = [true,false]
      contact.is_opt_out                = [true,false]
      # contact.legal_identifier
      # contact.external_identifier
      contact.homepage_url              = "http://fake.#{Faker::Internet.domain_name}"
      # contact.image_url
      contact.last_name                 = Faker::Name.last_name if contact.contact_type_id == 1
      contact.first_name                = Faker::Name.first_name if contact.contact_type_id == 1
      contact.organization_name         = Faker::Company.name if contact.contact_type_id == 2
      contact.household_name            = "#{Faker::Name.last_name} Family" if contact.contact_type_id == 3
      contact.nick_name                 = "#{contact.first_name}ster" if contact.contact_type_id == 1
      contact.legal_name                = "#{contact.organization_name.upcase}" if contact.contact_type_id == 2
      # contact.middle_name
      # contact.phonetic_last_name
      # contact.phonetic_first_name
      # contact.phonetic_middle_name
      contact.job_title                = ["Manager","Supervisor","Assistant","Programmer","Student","Homemaker","Teacher"] if contact.contact_type_id == 1
      # contact.mail_to_household_id
      # contact.head_of_household_id
      # contact.sic_code
      # contact.user_id
      # contact.assigned_to_user_id
      contact.lock_version             = 0
      contact.date_of_birth            = (45.years.ago..16.years.ago) if contact.contact_type_id == 1
      contact.government_identification_number = "123-45-6789"
      contact.is_foreign               = [true,false] if contact.contact_type_id == 1  
      contact.deceased_date            = (2.years.ago..2.months.ago) if contact.contact_type_id == 1 && contact.id == 190..200  
      contact.is_deceased              = true if contact.deceased_date && contact.contact_type_id == 1
      contact.created_at               = 1.years.ago..Time.now
      # contact.updated_at
      # contact.last_modified_by_user_id
      # contact.asset_id

      Phone.populate 1 do |phone|
        phone.contact_id = contact.id
        phone.location_type_id = [1,2,3,4,5]
        phone.is_primary = [true,false]
        phone.is_billing = [true,false]
        phone.mobile_provider_id = [1,2,3,4,5,6]
        phone.phone_type_id = [1,2,3,4]
        phone.phone = Faker::PhoneNumber.phone_number
      end
      
      Messenger.populate 1 do |messenger|
        messenger.contact_id = contact.id
        messenger.name = Faker::Internet.user_name
        messenger.location_type_id = [1,2,3,4,5]
        messenger.messaging_provider_id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        messenger.is_primary = [true,false]
        messenger.is_billing = [true,false]
      end

      Email.populate 1 do |email|
        email.contact_id = contact.id
        email.location_type_id = [1,2,3,4,5]
        email.address = Faker::Internet.email
        email.is_primary = [true,false]
        email.is_billing = [true,false]
        email.is_on_hold = [true,false]
        email.is_bulk_mail = [true,false]
      end

      Address.populate 1 do |address|
        address.contact_id = contact.id
        address.location_type_id = [1,2,3,4,5]
        address.is_primary = [true,false]
        address.is_billing = [true,false]
        address.line_1 = Faker::Address.street_address
        # address.line_2
        address.locality = Faker::Address.city
        address.region_id = Region.find_by_name(Faker::Address.us_state)
        address.country_id = Country.find_by_name("United States")
        address.postal_code = Faker::Address.zip_code
      end

    end
  end
end