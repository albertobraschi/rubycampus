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

require "rubycampus/rubycampus"

RubyCampus.defaults[:demo] = false
RubyCampus.defaults[:site_name] = 'RubyCampus'
RubyCampus.defaults[:site_protocal] = 'http://'                   # http:// or https://
RubyCampus.defaults[:site_url] = 'rubycampus.local'               # Deployment url (eg. rubycampus.org, site.rubycampus.org)
RubyCampus.defaults[:site_from_email] = 'admin@rubycampus.local'
RubyCampus.defaults[:site_title_default] = 'Relationship Management and Fundraising'
RubyCampus.defaults[:site_title_login] = 'Welcome to RubyCampus'

# Encrypts sensitive contact attributes stored within the database to meet and
# exceed information storage and retrieval requirments mandated by various agencies
# using U.S. Department of Homeland Security and National Security Agency approved
# cryptography
#
# WARNING: Think very carefully about whether you really need this information
#          encrypted. Please review your organizations policy regarding the
#          need to cryptographically protect attributes WITHIN the database
#          itself. This means YOUR DATABASE ADMINISTRATOR CANNOT READ ENCRYPTED
#          attributes and you will not be able to search on those attributes.
#
# Visit https://rubycampus.org for more information
RubyCampus.defaults[:encrypt_sensitive_attributes] = false

# RubyCampus domain-wide look and feel
RubyCampus.defaults[:domain_gui_calender_theme] = 'default'

# RubyCampus domain-wide display formats
CalendarDateSelect.format = :hyphen_ampm

# Default is Google Maps API for http://rubycampus.local
RubyCampus.defaults[:geocodable_service_api_key] = "ABQIAAAA_JjoUvqa134bquGy4vY15RRO4G5fyh1zZNzSCFmcvO7LZYRzsRT7v27fmOMDtR2bY8zj5aAhj8c8QQ"