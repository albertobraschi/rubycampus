# Generates Simulated Constituent Information for Development and Demo

# Required gems:
# sudo gem install populator faker echoe    

namespace :db do
  desc "Erase and fill database"
  task :demo => :environment do
    require 'populator'
    require 'faker'
    
    [Contact].each(&:delete_all)

    Contact.populate 100 do |contact|
      contact.domain_id = 1
      contact.contact_type_id = 1
      contact.stage_id = 200
      contact.entry_term_id = 1
      contact.academic_level_id = 1
      contact.education_level_id = 1
      
      contact.last_name    = Faker::Name.last_name
      contact.first_name   = Faker::Name.first_name
    end
  end
end

