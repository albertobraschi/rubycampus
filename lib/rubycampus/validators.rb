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

# NOTE Use _rubycampus_ in methods prevent potential conflicts with future revisions of
#      ActiveRecord::Validations::ClassMethods and to clearly distinguish among them.

module ActiveRecord
  module Validations
    module ClassMethods
      include GetText::Rails
      bindtextdomain("rubycampus")

      oct200 = "\303\200"
      oct226 = "\303\226"
      oct231 = "\303\231"
      oct266 = "\303\266"
      oct271 = "\303\271"
      oct277 = "\303\277"

      utf_accents = "#{oct200}-#{oct226}#{oct231}-#{oct266}#{oct271}-#{oct277}"

      @@is_rubycampus_not_from_options_msg = _("has a value other than the valid options below")

      @@is_rubycampus_required_msg = _("cannot be empty")
      @@is_rubycampus_required = /.+/

      @@is_rubycampus_human_name_msg = _("accepts only letters, hyphens, spaces, apostrophes, and periods")
      @@is_rubycampus_human_name = /^[a-zA-Z#{utf_accents}\.\'\-\ ]*?$/u

      @@is_rubycampus_organization_name_msg = _("accepts only letters, 0-9, hyphens, spaces, apostrophes, commas, and periods")
      @@is_rubycampus_organization_name = /^[a-zA-Z0-9#{utf_accents}\.\'\-\,\ ]*?$/u

      @@is_rubycampus_street_address_msg = _("accepts only letters, 0-9, hyphens, spaces, apostrophes, commas, periods, and number signs")
      @@is_rubycampus_street_address = /^[a-zA-Z0-9#{utf_accents}\.\'\-\,\#\ ]*?$/u

      @@is_rubycampus_alpha_msg = _("accepts only letters")
      @@is_rubycampus_alpha = /^[a-zA-Z#{utf_accents}]*?$/u

      @@is_rubycampus_alpha_space_msg = _("accepts only letters and spaces")
      @@is_rubycampus_alpha_space = /^[a-zA-Z#{utf_accents}\ ]*?$/u

      @@is_rubycampus_alpha_hyphen_msg = _("accepts only letters and hyphens")
      @@is_rubycampus_alpha_hyphen = /^[a-zA-Z#{utf_accents}\-]*?$/u

      @@is_rubycampus_alpha_underscore_msg = _("accepts only letters and underscores")
      @@is_rubycampus_alpha_underscore = /^[a-zA-Z#{utf_accents}\_]*?$/u

      @@is_rubycampus_alpha_symbol_msg = _('accepts only letters and !@#$%^&*')
      @@is_rubycampus_alpha_symbol = /^[a-zA-Z#{utf_accents}\!\@\#\$\%\^\&\*]*?$/u

      @@is_rubycampus_alpha_separator_msg = _("accepts only letters, underscores, hyphens, and spaces")
      @@is_rubycampus_alpha_separator = /^[a-zA-Z#{utf_accents}\_\-\ ]*?$/u

      @@is_rubycampus_alpha_numeric_msg = _("accepts only letters and 0-9")
      @@is_rubycampus_alpha_numeric = /^[a-zA-Z0-9#{utf_accents}]*?$/u

      @@is_rubycampus_alpha_numeric_space_msg = _("accepts only letters, 0-9, and spaces")
      @@is_rubycampus_alpha_numeric_space = /^[a-zA-Z0-9#{utf_accents}\ ]$/

      @@is_rubycampus_alpha_numeric_underscore_msg = _("accepts only letters, 0-9, and underscores")
      @@is_rubycampus_alpha_numeric_underscore = /^[a-zA-Z0-9#{utf_accents}\_]*?$/u

      @@is_rubycampus_alpha_numeric_hyphen_msg = _("accepts only letters, 0-9, and hyphens")
      @@is_rubycampus_alpha_numeric_hyphen = /^[a-zA-Z0-9#{utf_accents}\-]*?$/u

      @@is_rubycampus_alpha_numeric_symbol_msg = _('accepts only letters, 0-9, and !@#$%^&*')
      @@is_rubycampus_alpha_numeric_symbol = /^[a-zA-Z0-9#{utf_accents}\!\@\#\$\%\^\&\*]*?$/u

      @@is_rubycampus_alpha_numeric_separator_msg = _("accepts only letters, 0-9, underscore, hyphen, and space")
      @@is_rubycampus_alpha_numeric_separator = /^[a-zA-Z0-9#{utf_accents}\_\-\ ]*?$/u

      @@is_rubycampus_numeric_msg = _("accepts only numeric characters (0-9)")
      @@is_rubycampus_numeric = /^[0-9]*?$/

      @@is_rubycampus_decimal_msg = _("accepts only numeric characters, period, and negative sign (no commas, requires at least .0)")
      @@is_rubycampus_decimal = /^-{0,1}\d*\.{0,1}\d+$/

      @@is_rubycampus_positive_decimal_msg = _("accepts only numeric characters and period (no commas, requires at least .0)")
      @@is_rubycampus_positive_decimal = /^\d*\.{0,1}\d+$/

      @@is_rubycampus_integer_msg = _("accepts only numeric characters, and negative sign (no commas)")
      @@is_rubycampus_integer = /^-{0,1}\d+$/

      @@is_rubycampus_positive_integer_msg = _("accepts positive integer only (no commas)")
      @@is_rubycampus_positive_intger = /^\d+$/

      @@is_rubycampus_email_address_msg = _("must contain an @ symbol, at least one period after the @, and one A-Z letter in each segment")
      @@is_rubycampus_email_address = /^[A-Z0-9._%-]+@[A-Z0-9._%-]+\.[A-Z]{2,4}$/i

      def do_as_format_of(attr_names, configuration)
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
        if configuration.has_key?(:label)
          msg_string = _("The field <span class=\"inputErrorFieldName\">#{configuration[:label]}</span> #{configuration[:message]}.")
        else
          msg_string = _("This field #{configuration[:message]}")
        end
        configuration.store(:message, msg_string)
        configuration.delete(:label)
        validates_format_of attr_names, configuration
      end

      def do_as_inclusion_of(attr_names, configuration)
        configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
        if configuration.has_key?(:label)
          msg_string = _("The field <span class=\"inputErrorFieldName\">#{configuration[:label]}</span> #{configuration[:message]}.")
        else
          msg_string = _("This field #{configuration[:message]}")
        end
        configuration.store(:message, msg_string)
        configuration.delete(:label)
        validates_inclusion_of attr_names, configuration
      end

      def validates_as_rubycampus_required(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_required_msg,
          :with      => @@is_rubycampus_required }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_human_name(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_human_name_msg,
          :with      => @@is_rubycampus_human_name }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_organization_name(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_organization_name_msg,
          :with      => @@is_rubycampus_organization_name }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_street_address(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_street_address_msg,
          :with      => @@is_rubycampus_street_address }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_msg,
          :with      => @@is_rubycampus_alpha }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_space(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_space_msg,
          :with      => @@is_rubycampus_alpha_space }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_hyphen(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_hyphen_msg,
          :with      => @@is_rubycampus_alpha_hyphen }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_underscore(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_underscore_msg,
          :with      => @@is_rubycampus_alpha_underscore }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_symbol(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_symbol_msg,
          :with      => @@is_rubycampus_alpha_symbol }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_separator(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_separator_msg,
          :with      => @@is_rubycampus_alpha_separator }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_msg,
          :with      => @@is_rubycampus_alpha_numeric }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric_space(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_space_msg,
          :with      => @@is_rubycampus_alpha_numeric_space }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric_hyphen(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_hyphen_msg,
          :with      => @@is_rubycampus_alpha_numeric_hyphen }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric_underscore(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_underscore_msg,
          :with      => @@is_rubycampus_alpha_numeric_underscore }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric_symbol(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_symbol_msg,
          :with      => @@is_rubycampus_alpha_numeric_symbol }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_alpha_numeric_separator(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_alpha_numeric_separator_msg,
          :with      => @@is_rubycampus_alpha_numeric_separator }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_numeric(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_numeric_msg,
          :with      => @@is_rubycampus_numeric }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_decimal(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_decimal_msg,
          :with      => @@is_rubycampus_decimal }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_positive_decimal(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_positive_decimal_msg,
          :with      => @@is_rubycampus_positive_decimal }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_integer(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_integer_msg,
          :with      => @@is_rubycampus_integer }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_positive_integer(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_positive_integer_msg,
          :with      => @@is_rubycampus_positive_integer }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_email(*attr_names)
        configuration = {
          :message   => @@is_rubycampus_email_address_msg,
          :with      => @@is_rubycampus_email_address }
        do_as_format_of(attr_names, configuration)
      end

      def validates_as_rubycampus_value_list(*attr_names)
        configuration = {
          :message => @@is_rubycampus_not_from_options_msg }
        do_as_inclusion_of(attr_names, configuration)
      end

    end
  end
end
