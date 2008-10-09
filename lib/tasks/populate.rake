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

# This task generates simulated constituent information 
# sutable for development and demoing purposes.
#
# Requires additional gems -> sudo gem install populator faker echoe

namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    # Truncates Models
    [Contact,Address,Email,Messenger,Phone].each(&:delete_all)

    # Creates array from values returned by model with block
    academic_levels                     = AcademicLevel.find(:all).map { |val| val.id }
    citizenships                        = Citizenship.find(:all).map { |val| val.id }
    contact_types                       = ContactType.find(:all).map { |val| val.id }
    country_of_births                   = CountryOfBirth.find(:all).map { |val| val.id }
    education_levels                    = EducationLevel.find(:all).map { |val| val.id }
    entry_terms                         = EntryTerm.find(:all).map { |val| val.id }
    ethnicities                         = Ethnicity.find(:all).map { |val| val.id }
    genders                             = Gender.find(:all).map { |val| val.id }
    greetings                           = Greeting.find(:all).map { |val| val.id }
    location_types                      = LocationType.find(:all).map { |val| val.id }
    marital_statuses                    = MaritalStatus.find(:all).map { |val| val.id }
    messaging_providers                 = MessagingProvider.find(:all).map { |val| val.id }
    mobile_providers                    = MobileProvider.find(:all).map { |val| val.id }
    name_prefixes                       = NamePrefix.find(:all).map { |val| val.id }
    name_suffixes                       = NameSuffix.find(:all).map { |val| val.id }
    nationalities                       = Nationality.find(:all).map { |val| val.id }
    phone_types                         = PhoneType.find(:all).map { |val| val.id }
    preferred_communication_methods     = PreferredCommunicationMethod.find(:all).map { |val| val.id }
    preferred_email_formats             = PreferredEmailFormat.find(:all).map { |val| val.id }
    programs                            = Program.find(:all).map { |val| val.id }   
    sources                             = Source.find(:all).map { |val| val.id }
    stages                              = Stage.find(:all).map { |val| val.id }
    # Not in models
    job_titles                          = ["Manager","Supervisor","Assistant","Programmer","Student","Homemaker","Teacher"]

    Contact.populate 200 do |contact|
      contact.domain_id                 = 1
      contact.academic_level_id         = academic_levels if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.citizenship_id            = citizenships if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.contact_type_id           = contact_types
      contact.country_of_birth_id       = country_of_births if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.education_level_id        = education_levels if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.entry_term_id             = entry_terms if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.ethnicity_id              = ethnicities if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.gender_id                 = genders if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.greeting_id               = greetings if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.marital_status_id         = marital_statuses if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.name_prefix_id            = name_prefixes if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.name_suffix_id            = name_suffixes if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.nationality_id            = nationalities if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.preferred_communication_method_id = preferred_communication_methods
      contact.preferred_email_format_id = preferred_email_formats
      contact.program_id                = programs if contact.contact_type_id == ContactType::INDIVIDUAL.id  
      contact.source_id                 = sources
      contact.stage_id                  = stages if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.do_not_email              = [true,false]
      contact.do_not_phone              = [true,false]
      contact.do_not_mail               = [true,false]
      contact.do_not_trade              = [true,false]
      contact.is_opt_out                = [true,false]
      # contact.legal_identifier
      # contact.external_identifier
      contact.homepage_url              = "http://fake.#{Faker::Internet.domain_name}"
      # contact.image_url
      contact.last_name                 = Faker::Name.last_name if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.first_name                = Faker::Name.first_name if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.organization_name         = Faker::Company.name if contact.contact_type_id == ContactType::ORGANIZATION.id
      contact.household_name            = "#{Faker::Name.last_name} Family" if contact.contact_type_id == ContactType::HOUSEHOLD.id
      contact.nick_name                 = "#{contact.first_name}ster" if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.legal_name                = "#{contact.organization_name.upcase}" if contact.contact_type_id == ContactType::ORGANIZATION.id
      # contact.middle_name
      # contact.phonetic_last_name
      # contact.phonetic_first_name
      # contact.phonetic_middle_name
      contact.job_title                = job_titles if contact.contact_type_id == ContactType::INDIVIDUAL.id
      # contact.mail_to_household_id
      # contact.head_of_household_id
      # contact.sic_code
      # contact.user_id
      # contact.assigned_to_user_id
      contact.lock_version             = 0
      contact.date_of_birth            = (45.years.ago..16.years.ago) if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.government_identification_number = "123-45-6789"
      contact.is_foreign               = [true,false] if contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.deceased_date            = (2.years.ago..2.months.ago) if contact.contact_type_id == ContactType::INDIVIDUAL.id && contact.id == 190..200
      contact.is_deceased              = true if contact.deceased_date && contact.contact_type_id == ContactType::INDIVIDUAL.id
      contact.created_at               = 1.years.ago..Time.now
      contact.updated_at               = contact.created_at
      # contact.last_modified_by_user_id
      # contact.asset_id
      contact.revisable_number = 1                 # Required to trick our revision control system into accepting record
      contact.revisable_is_current = 1             # Required to trick our revision control system into accepting record
      
      Address.populate 1 do |address|
        address.contact_id = contact.id
        address.location_type_id = location_types
        address.is_primary = [true,false]
        address.is_billing = [true,false]
        address.line_1 = Faker::Address.street_address
        # address.line_2
        address.locality = Faker::Address.city
        address.region_id = Region.find_by_name(Faker::Address.us_state)
        address.country_id = Country.find_by_name("United States")
        address.postal_code = Faker::Address.zip_code
        address.revisable_number = 1                 # Required to trick our revision control system into accepting record
        address.revisable_is_current = 1             # Required to trick our revision control system into accepting record
      end

      Email.populate 1 do |email|
        email.contact_id = contact.id
        email.location_type_id = location_types
        email.address = Faker::Internet.email
        email.is_primary = [true,false]
        email.is_billing = [true,false]
        email.is_on_hold = [true,false]
        email.is_bulk_mail = [true,false]
        email.revisable_number = 1                 # Required to trick our revision control system into accepting record
        email.revisable_is_current = 1             # Required to trick our revision control system into accepting record
      end

      Messenger.populate 1 do |messenger|
        messenger.contact_id = contact.id
        messenger.name = Faker::Internet.user_name
        messenger.location_type_id = location_types
        messenger.messaging_provider_id = messaging_providers
        messenger.is_primary = [true,false]
        messenger.is_billing = [true,false]
        messenger.revisable_number = 1              # Required to trick our revision control system into accepting record
        messenger.revisable_is_current = 1          # Required to trick our revision control system into accepting record
      end

      Phone.populate 1 do |phone|
        phone.contact_id = contact.id
        phone.location_type_id = location_types
        phone.is_primary = [true,false]
        phone.is_billing = [true,false]
        phone.mobile_provider_id = mobile_providers
        phone.phone_type_id = phone_types
        phone.phone = Faker::PhoneNumber.phone_number
        phone.revisable_number = 1                 # Required to trick our revision control system into accepting record
        phone.revisable_is_current = 1             # Required to trick our revision control system into accepting record
      end

    end
  end
end