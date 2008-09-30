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
#
# *-W-A-R-N-I-N-G-**********************************************************************
# * THESE SETTINGS SHOULD NOT BE CHANGED AS THEY ARE ESSENTIAL AND ABSOLUTELY REQUIRED * 
# * FOR RUBYCAMPUS TO PROPERLY OPERATE. MODIFICATIONS BEYOND THIS POINT WILL LIKELY    *
# * CAUSE DATA STORED IN YOUR RUBYCAMPUS DATABASE TO BE INCOMPATIBLE WITH ALL FUTURE   *
# * RUBYCAMPUS RELEASES, MODULES, COMPONENTS, CORE METHODS AND SPECIFICATION TEST.     *
# **************************************************************************************
#++   

ROWS_PER_PAGE = 15 # for :per_page => ROWS_PER_PAGE in pagination
 
# Tables and Defaults
RUBYCAMPUS = "rubycampus"
RUBYCAMPUS_EDITION = "RubyCampus"
RUBYCAMPUS_CORE_TABLE_PREFIX = RUBYCAMPUS + "_"
RUBYCAMPUS_CORE_COUNTRIES_TABLE = RUBYCAMPUS_CORE_TABLE_PREFIX + 'countries'
RUBYCAMPUS_HEAD_OF_HOUSEHOLD_TABLE = RUBYCAMPUS_CORE_TABLE_PREFIX + 'contacts'
RUBYCAMPUS_PATH_TO_DEFAULTS = "lib/#{RUBYCAMPUS}/defaults"
RUBYCAMPUS_ORG_BASE_URL = 'https://rubycampus.org/'

# Debug CSS
SHOWGRID = false 
 
# Used to indicate which fields can be merged (i.e. mail merge)
TOKENS = %w{{contact.academic_level}
            {contact.assigned_to_user}
            {contact.citizenship}
            {contact.contact_type}
            {contact.country_of_birth}
            {contact.created_at}
            {contact.date_of_birth}
            {contact.deceased_date}
            {contact.do_not_email}
            {contact.do_not_mail}
            {contact.do_not_phone}
            {contact.do_not_trade}
            {contact.education_level}
            {contact.entry_term}
            {contact.ethnicity}
            {contact.external_identifier}
            {contact.first_name}
            {contact.gender}
            {contact.greeting}
            {contact.homepage_url}
            {contact.household_name}
            {contact.id}
            {contact.is_deceased}
            {contact.is_foreign}
            {contact.is_opt_out}
            {contact.job_title}
            {contact.language}
            {contact.last_name}
            {contact.legal_identifier}
            {contact.legal_name}
            {contact.marital_status}
            {contact.middle_name}
            {contact.moodle_user}
            {contact.name_prefix}
            {contact.name_suffix}
            {contact.nationality}
            {contact.nick_name}
            {contact.organization_name}
            {contact.program}
            {contact.sic_code}
            {contact.source}
            {contact.stage}
            {contact.time_zone}
            {contact.updated_at}}  

# Load RubyCampus SDK hook if present
begin
  require "rubycampus/sdk"
rescue LoadError
end