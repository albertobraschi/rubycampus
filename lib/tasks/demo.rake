# Generates Simulated Constituent Information for Development and Demo

# Required gems:
# sudo gem install populator faker echoe

namespace :db do
  desc "Erase and fill database"
  task :demo => :environment do
    require 'populator'
    require 'faker'

    [Contact, Address, Phone, Email, Messenger].each(&:delete_all)

    Contact.populate 100 do |contact|
      # contact.id
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
      contact.do_not_email              = [0,1]
      contact.do_not_phone              = [0,1]
      contact.do_not_mail               = [0,1]
      contact.do_not_trade              = [0,1]
      contact.is_opt_out                = [0,1]
      # contact.legal_identifier
      # contact.external_identifier
      # contact.nick_name
      # contact.legal_name
      contact.homepage_url              = "http://fake.#{Faker::Internet.domain_name}"
      # contact.image_url
      contact.last_name                 = Faker::Name.last_name if contact.contact_type_id == 1
      contact.first_name                = Faker::Name.first_name if contact.contact_type_id == 1
      # contact.middle_name
      # contact.phonetic_last_name
      # contact.phonetic_first_name
      # contact.phonetic_middle_name
      # contact.job_title
      # contact.deceased_date
      # contact.mail_to_household_id
      contact.household_name           = "#{Faker::Name.last_name} Family" if contact.contact_type_id == 3
      # contact.head_of_household_id
      contact.organization_name        = Faker::Company.name if contact.contact_type_id == 2
      # contact.sic_code
      # contact.user_id
      # contact.assigned_to_user_id
      # contact.lock_version
      # contact.date_of_birth
      # contact.government_identification_number
      contact.is_foreign               = [0,1] if contact.contact_type_id == 1
      # contact.is_deceased
      # contact.created_at
      # contact.updated_at
      # contact.last_modified_by_user_id
      # contact.asset_id

      Phone.populate 1 do |phone|
        phone.contact_id = contact.id
        phone.location_type_id = [1,2,3,4,5]
        phone.is_primary = [0,1]
        phone.is_billing = [0,1]
        phone.mobile_provider_id = [1,2,3,4,5,6]
        phone.phone_type_id = [1,2,3,4]
        phone.phone = Faker::PhoneNumber.phone_number
      end
      
      Messenger.populate 1 do |messenger|
        messenger.contact_id = contact.id
        messenger.name = Faker::Internet.user_name
        messenger.location_type_id = [1,2,3,4,5]
        messenger.messaging_provider_id = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
        messenger.is_primary = [0,1]
        messenger.is_billing = [0,1]
      end

      Email.populate 1 do |email|
        email.contact_id = contact.id
        email.location_type_id = [1,2,3,4,5]
        email.address = Faker::Internet.email
        email.is_primary = [0,1]
        email.is_billing = [0,1]
        email.is_on_hold = [0,1]
        email.is_bulk_mail = [0,1]
      end

      Address.populate 1 do |address|
        address.contact_id = contact.id
        address.location_type_id = [1,2,3,4,5]
        address.is_primary = [0,1]
        address.is_billing = [0,1]
        address.line_1 = Faker::Address.street_address
        address.locality = Faker::Address.city
        address.region_id = Region.find_by_name(Faker::Address.us_state)
        address.country_id = Country.find_by_name("United States")
        address.postal_code = Faker::Address.zip_code
      end

    end
  end
end




