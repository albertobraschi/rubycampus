#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Student & Alumni Relationship Management Software                     |
# +------------------------------------------------------------------------------------+
# | Copyright © 2008-2009 Kevin R. Aleman. Fukuoka, Japan. All Rights Reserved.        |
# +------------------------------------------------------------------------------------+
# |                                                                                    |
# | This program is free software; you can redistribute it and/or modify it under the  |
# | terms of the GNU Affero General Public License version 3 as published by the Free  |
# | Software Foundation with the addition of the following permission added to Section |
# | 15 as permitted in Section 7(a): FOR ANY PART OF THE COVERED WORK IN WHICH THE     |
# | COPYRIGHT IS OWNED BY KEVIN R ALEMAN, KEVIN R ALEMAN DISCLAIMS THE WARRANTY OF NON |
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
# | You can contact the author Kevin R. Aleman by email at KALEMAN@RUBYCAMPUS.ORG. The |
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
  module Sidebar
    
    # generate your sidebars directory with the following task:
    # rake sidebar:install
    # == display_sidebar
    # displays a sidebar, it will search for sidebar partial files in the following areas:
    # 1. views/sidebars/[:controller]/[:action] # => action specific sidebar
    # 2. views/sidebars/[:controller]/global # => controller specific sidebar
    # 3. views/sidebars/global # => app wide specific sidebar
    # to generate a sidebar skeleton dir, use the following rake task
    # rake sidebar:generate FOR='controller/action'
    # you can set the message to display by passing it in the block
    # display_sidebar { "Nothing to see" } # => will display "Nothing to see" if sidebar isn't 
    #                                           found
    # you can specify a wrapping element by using the following syntax
    # display_sidebar :inside => '<div id="sidebars">yield</div>'
    #         - yield will be substituted with the sidebar
    # 
    def display_sidebar(options={}, &block)
      options[:inside] ||= ""
      sidebar_partial = "sidebars/#{params[:controller]}/#{params[:action]}"
      sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars", params[:controller], 
                              "_#{params[:action]}.html.haml")

      controller_sidebar_partial = "sidebars/#{params[:controller]}/global"                        
      controller_sidebar_file = File.join(RAILS_ROOT, "app/views/sidebars/#{params[:controller]}/_global.html.haml")

      global_sidebar_file = "#{RAILS_ROOT}/app/views/sidebars/_global.html.haml"
      global_sidebar_partial = "sidebars/global"

      if File.exists?(sidebar_file)
        side_bar = render(:partial => sidebar_partial) 
        options[:inside].blank? ? side_bar : options[:inside].gsub("yield",side_bar)
      elsif File.exists?(controller_sidebar_file)
        side_bar = render :partial => controller_sidebar_partial
        options[:inside].blank? ? side_bar : options[:inside].gsub("yield",side_bar)
      else
        content = "" || yield
        File.exists?(global_sidebar_file) ? render(:partial => global_sidebar_partial) : content
      end
    end
    
    # if you need to quickly copy a sidebar from another within the same
    # controller, here's the easy way :
    # copy_from :name_of_sidebar
    #   # => render :partial => 'sidebars/#{params[:controller]}/#{sidebar}'
    # you can also copy a sidebar from another controller by passing the controller hash
    # copy_from :index, :controller => "home"
    #   # => render :partial => 'sidebars/home/index.html.haml'
    def copy_from(sidebar, options={})
      options[:controller] ||= params[:controller] 
      render :partial => "sidebars/#{options[:controller]}/#{sidebar.to_s}" 
    end
    
  end
end