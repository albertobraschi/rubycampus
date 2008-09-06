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

class Contact < ActiveRecord::Base 
  # Encrypts sensitive information INSIDE database
  if RubyCampus.encrypt_sensitive_attributes
    acts_as_secure :crypto_provider => MasterCryptoProvider
  end
  
  # begin Associations
    belongs_to :academic_level
    belongs_to :citizenship
    belongs_to :contact_type
    belongs_to :country_of_birth
    belongs_to :education_level
    belongs_to :entry_term
    belongs_to :ethnicity
    belongs_to :gender
    belongs_to :greeting
    belongs_to :head_of_household
    belongs_to :marital_status
    belongs_to :name_prefix
    belongs_to :name_suffix
    belongs_to :nationality
    belongs_to :preferred_communication_method
    belongs_to :preferred_email_format
    belongs_to :source
    belongs_to :stage
     
    has_many :activities,   :dependent => :destroy
    has_many :addresses,    :dependent => :destroy
    has_many :emails,       :dependent => :destroy
    has_many :messengers,   :dependent => :destroy
    has_many :phones,       :dependent => :destroy
    has_one  :asset,        :dependent => :destroy # Unimplemented  
  # end Associations 
  
  # TODO allow auto_complete of assignable users  
  # belongs_to :user, :class_name => "User", :foreign_key => "assigned_to_user_id"
  
  # TODO incompatible with presenter pattern
  # begin RESTful_ACL
    # def is_updatable_by(user)
    #   true
    # end
    # 
    # def is_deletable_by(user)
    #   true
    # end
    # 
    # def self.is_readable_by(user, object = nil)
    #   true
    # end
    # 
    # def self.is_creatable_by(user)
    #   true
    # end     
  # end RESTful_ACL
  
  # begin Validations
    # for Individuals Presenter
    validates_presence_of :last_name, :if => Proc.new { |contact| contact.contact_type_id == INDIVIDUAL }
    validates_presence_of :first_name, :if => Proc.new { |contact| contact.contact_type_id == INDIVIDUAL }
  
    # for Organizations Presenter
    validates_presence_of :organization_name, :if => Proc.new { |contact| contact.contact_type_id == ORGANIZATION } 
  
    # for Households Presenter
    validates_presence_of :household_name, :if => Proc.new { |contact| contact.contact_type_id == HOUSEHOLD }
  
    # for all models  
    validates_as_rubycampus_human_name :first_name, :last_name, :middle_name
    validates_as_rubycampus_organization_name :organization_name   
  # end Validations
  
  # begin Searchable
    searchable_by :first_name, :last_name, :organization_name, :household_name   
  # end Searchable
  
  # begin Queries
    # Required scope for segmenting contact_types
    def self.with_contact_type(contact_type)
      with_scope(:find => { :conditions => ["contact_type_id = ?", contact_type] } ) do
        yield
      end 
    end
    
    # Fetches scoped contacts with pagination
    def self.search_for_all_and_paginate(search, page, contact_type)
      with_contact_type(contact_type) { search(search).paginate( :page => page, :per_page => ROWS_PER_PAGE, :order => 'updated_at ASC' ) }
    end 
  
    # Fetches all contacts with pagination
    def self.search_for_all_contact_types_and_paginate(search, page)
      search(search).paginate( :page => page, :per_page => ROWS_PER_PAGE, :order => 'updated_at ASC' )
    end
  
    # Lists qualifying model attributes for use by auto completion in forms
    # TODO Create virtual attribute combining 
    # last_name, first_name, organization_name, household_name
    def self.find_for_auto_complete_lookup(search)
      find(:all, :conditions => ['last_name LIKE ?', "%#{search}%"])  
    end   
  # end Queries

#:stopdoc:
  # Virtual Attributes for auto complete
    # begin stage
      def stage_name
        stage.name if stage
      end

      def stage_name=(name)
        self.stage = Stage.find_by_name(name) unless name.blank?
      end
    # end stage 

    # begin source    
      def source_name
        source.name if source
      end

      def source_name=(name)
        self.source = Source.find_or_create_by_name(name) unless name.blank?
      end
    # end source
    
    # begin entry_term        
      def entry_term_name
        entry_term.name if entry_term
      end

      def entry_term_name=(name)
        self.entry_term = EntryTerm.find_or_create_by_name(name) unless name.blank?
      end
    # end entry_term        

    # begin education_level        
      def education_level_name
        education_level.name if education_level
      end

      def education_level_name=(name)
        self.education_level = EducationLevel.find_or_create_by_name(name) unless name.blank?
      end
    # end education_level
    
    # begin academic_level   
      def academic_level_name
        academic_level.name if academic_level
      end

      def academic_level_name=(name)
        self.academic_level = AcademicLevel.find_or_create_by_name(name) unless name.blank?
      end
    # end academic_level
    
    # begin name_prefix   
      def name_prefix_name
        name_prefix.name if name_prefix
      end

      def name_prefix_name=(name)
        self.name_prefix = NamePrefix.find_or_create_by_name(name) unless name.blank?
      end
    # end name_prefix
    
    # begin name_suffix  
      def name_suffix_name
        name_suffix.name if name_suffix
      end

      def name_suffix_name=(name)
        self.name_suffix = NameSuffix.find_or_create_by_name(name) unless name.blank?
      end
    # end name_suffix  
    
    # begin marital_status  
      def marital_status_name
        marital_status.name if marital_status
      end

      def marital_status_name=(name)
        self.marital_status = MaritalStatus.find_or_create_by_name(name) unless name.blank?
      end
    # end marital_status
    
    # begin gender
      def gender_name
        gender.name if gender
      end

      def gender_name=(name)
        self.gender = Gender.find_by_name(name) unless name.blank?
      end
    # end gender
    
    # begin ethnicity
      def ethnicity_name
        gender.name if gender
      end

      def ethnicity_name=(name)
        self.ethnicity = Ethnicity.find_or_create_by_name(name) unless name.blank?
      end 
    # end ethnicity
    
    # begin country_of_birth
      def country_of_birth_name
        country_of_birth.name if country_of_birth
      end

      def country_of_birth_name=(name)
        self.country_of_birth = CountryOfBirth.find_by_name(name) unless name.blank?
      end
    # end country_of_birth
     
    # begin citizenship
      def citizenship_name
        citizenship.name if citizenship
      end

      def citizenship_name=(name)
        self.citizenship = Citizenship.find_by_name(name) unless name.blank?
      end 
    # end citizenship
    
    # begin nationality
      def nationality_name
        nationality.name if nationality
      end

      def nationality_name=(name)
        self.nationality = Nationality.find_by_name(name) unless name.blank?
      end
    # end nationality
    
    # begin head_of_household_last_name
      def head_of_household_last_name
        head_of_household.last_name if head_of_household
      end

      def head_of_household_last_name=(last_name)
        self.head_of_household = HeadOfHousehold.find_by_last_name(last_name) unless last_name.blank?
      end
    # end head_of_household_last_name
#:startdoc:  
end
# == Schema Information
# Schema version: 20080902230656
#
# Table name: rubycampus_contacts
#
#  id                                :integer(11)     not null, primary key
#  domain_id                         :integer(11)     default(1), not null
#  stage_id                          :integer(11)
#  entry_term_id                     :integer(11)
#  contact_type_id                   :integer(11)
#  preferred_communication_method_id :integer(11)
#  preferred_email_format_id         :integer(11)
#  source_id                         :integer(11)
#  name_prefix_id                    :integer(11)
#  name_suffix_id                    :integer(11)
#  marital_status_id                 :integer(11)
#  citizenship_id                    :integer(11)
#  nationality_id                    :integer(11)
#  ethnicity_id                      :integer(11)
#  education_level_id                :integer(11)
#  academic_level_id                 :integer(11)
#  gender_id                         :integer(11)
#  country_of_birth_id               :integer(11)
#  greeting_id                       :integer(11)
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
#  mail_to_household_id              :integer(11)
#  household_name                    :string(255)
#  head_of_household_id              :integer(11)
#  organization_name                 :string(255)
#  sic_code                          :string(255)
#  user_id                           :integer(11)
#  assigned_to_user_id               :integer(11)
#  lock_version                      :integer(11)     default(0)
#  date_of_birth                     :date
#  government_identification_number  :binary
#  is_foreign                        :boolean(1)
#  is_deceased                       :boolean(1)
#  created_at                        :datetime
#  updated_at                        :datetime
#  last_modified_by_user_id          :integer(11)
#  asset_id                          :integer(11)
#

