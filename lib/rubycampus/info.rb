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

module Rubycampus
  module Info
    class << self
      def name; 'RubyCampus' end
      def keywords; 'rubycampus,relationship management,alumni development,fundraising,higher education' end
      def version; Rubycampus::Build::version[:string] end
      def impressum
        val = "© 2008 <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}\">RubyCampus LLC</a> All Rights Reserved.<br>Powered by #{RUBYCAMPUS_EDITION} #{Rubycampus::Build::version[:string]}<br><a href=\"#{RUBYCAMPUS_ORG_BASE_URL}wiki/#{RUBYCAMPUS}/download\">Download</a> | <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}projects/#{RUBYCAMPUS}/issues\">Issue Tracker</a> | <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}wiki/#{RUBYCAMPUS}\">Wiki</a>"
        if Setting.demo?
          val << <<-EOF
            <br/><blockquote>Constituent records for this demo though realistic are<br/>
            fictitious and <a target="_blank" href="#{RUBYCAMPUS_ORG_BASE_URL}repositories/entry/#{RUBYCAMPUS}/lib/tasks/populate.rake">randomly generated</a>. 
            <br/>Login: <strong>admin</strong> Password: <strong>password</strong></blockquote>
            <script type="text/javascript">
            var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
            document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
            </script>
            <script type="text/javascript">
            var pageTracker = _gat._getTracker("UA-4059064-4");
            pageTracker._trackPageview();
            </script>  
            EOF
        end
        val
      end
      def extract_generated_by; "Generated by #{RUBYCAMPUS_EDITION}" end
      def extract_header_logo; "#{RAILS_ROOT}/public/images/#{RUBYCAMPUS}/logo.png" end
    end
  end
end