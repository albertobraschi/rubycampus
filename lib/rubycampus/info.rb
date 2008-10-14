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
      def powered_by
        "<a href=\"#{RUBYCAMPUS_ORG_BASE_URL}\" title=\"Powered by RubyCampus\"><img src=\"/images/powered_by_rubycampus.png\" alt=\"Powered by RubyCampus\"></a>"
      end
      def impressum
        val = "© 2008 <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}\">RubyCampus LLC</a> All Rights Reserved.<br/>Powered by #{RUBYCAMPUS_EDITION} #{Rubycampus::Build::version[:string]}<br/><a href=\"#{RUBYCAMPUS_ORG_BASE_URL}wiki/#{RUBYCAMPUS}/download\">Download</a> | <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}projects/#{RUBYCAMPUS}/issues\">Issue Tracker</a> | <a href=\"#{RUBYCAMPUS_ORG_BASE_URL}wiki/#{RUBYCAMPUS}\">Wiki</a><br/><br/>#{Rubycampus::Info::powered_by}"
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
      def about;
        <<-EOF
          <h2>RubyCampus Community Edition</h2>
          <h4>Version #{Rubycampus::Build::version[:string]}</h4>
          <p>
          Copyright © 2008 Kevin R. Aleman, RubyCampus LLC. The Program is provided AS IS, without warranty. Licensed under <a 
          href="/license">AGPLv3</a>. This program is free software; you can redistribute it and/or modify it under the terms 
          of the <a href="/license">GNU Affero General Public License version 3</a> as published by the Free Software Foundation 
          including the additional permission set forth in the source code header.
          </p>
          <div class="clear"></div>
          #{Rubycampus::Info::powered_by}
          <div class="clear"></div>
          <p>
          The interactive user interfaces in modified source and object code versions of this program must display Appropriate Legal
          Notices, as required under Section 5 of the GNU Affero General Public License version 3. In accordance with Section 7(b) of
          the GNU Affero General Public License version 3, these Appropriate Legal Notices must retain the display of the "Powered by
          RubyCampus" logo. If the display of the logo is not reasonably feasible for technical reasons, the Appropriate Legal 
          Notices
          must display the words "Powered by RubyCampus".
          <br/><br/>
          RubyCampus™, RubyCampus Community Edition™ are <a href="https://rubycampus.org/wiki/rubycampus/Licensing"
           title="trademarks">trademarks</a> of Kevin R. Aleman and are governed by guidelines set forth in the <a 
          href="https://rubycampus.org/wiki/rubycampus/Licensing" title="trademarks">trademarks and licensing</a> wiki page.
          </p>
          <h3>RubyCampus Community Resources</h3>
          <p>Visit our <a href="#{RUBYCAMPUS_ORG_BASE_URL}">forge and community</a> and find out which individuals and organizations 
          actively <a href="https://rubycampus.org/wiki/rubycampus/Community_Contributors">contribute</a> to the advancement of
          RubyCampus.
          </p>
        EOF
      end
      def license;
        begin
        license = File.readlines("#{RAILS_ROOT}/doc/LICENSE").map {|l| l}
        <<-EOF
          <h2>RubyCampus Software License</h2> 
          <pre> 
          #{license}
          </pre>
        EOF
        rescue
        "<h1>License Missing</h1>
        <h2>If you are reading this message it means someone has removed the license covering the use of the source code powering
        this software located in the doc/LICENSE file.
        <br/><br/>
        Please speak to your administrator regarding the missing license or contact 
        us at <a href=\"mailto:license@rubycampus.org\">license@rubycampus.org</a></h2>"
        end
      end
    end
  end
end