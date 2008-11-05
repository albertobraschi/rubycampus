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

module AdministersHelper

  #
  # Renders settings input and labels
  #
  # Accepts: label_for_setting :setting => :site_name,      <-- Required 
  #                                        :example => _("The example"), 
  #                                        :width => "w100", 
  #                                        :input_type => :radiocheck,
  #                                        :mandatory => true,
  #
  def label_for_setting(opts={})
    setting = opts[:setting].to_s
    example = opts[:example] || ''
    width = opts[:width] || 'w100'
    input_type = opts[:input_type] || 'inputselect'
    mandatory = opts[:mandatory] ? 'mandatory' : ''
    label = opts[:label] || opts[:setting].to_s
    
    case input_type.to_sym
    when :inputselect || nil
    (content_tag(:label, 
                 (
                 content_tag(:span,(content_tag(:span,_(label.humanize.titleize),:class => "title")) + (
                 content_tag(:span, ' ' + _(example), :class => "example") unless example == nil) + (
                 text_field_tag "settings[#{setting}]", Setting.send(setting), :class => "field"), 
                 :class => "wrapper")), :for => "setting_#{setting}", :class => "#{width} #{input_type} #{mandatory}"))
    when :inputselect_password
    (content_tag(:label, 
                (
                content_tag(:span,(content_tag(:span,_(label.humanize.titleize),:class => "title")) + (
                content_tag(:span, ' ' + _(example), :class => "example") unless example == nil) + (
                password_field_tag "settings[#{setting}]", Setting.send(setting), :class => "field"), 
                :class => "wrapper")), :for => "setting_#{setting}", :class => "#{width} #{input_type} #{mandatory}"))             
    when :radiocheck
      (content_tag(:label, 
                   (
                   content_tag(:span,(content_tag(:span, ' ' + _(example), :class => "example") unless example == nil) + "<br/>" +(
                   check_box_tag "settings[#{setting}]", 1, Setting.send(setting+"?") , :class => "select") + (
                   hidden_field_tag "settings[#{setting}]", 0) + (
                   content_tag(:span,_(label.humanize.titleize),:class => "title")), :class => "wrapper")), 
                   :for => "setting_#{setting}", :class => "#{width} #{input_type} #{mandatory}"))    
    else
      "Input Type doesn't exist"
    end
  # <%= check_box_tag 'settings[default_projects_public]', 1, Setting.default_projects_public? %><%= hidden_field_tag 'settings[default_projects_public]', 0 %></p>    
  end
  
  def administer_setting_tabs
    tabs = [{:name => 'general', :partial => 'administers/settings/general', :label => _("General")},
            {:name => 'domain', :partial => 'administers/settings/domain', :label => _("Domain")},
            {:name => 'mail', :partial => 'administers/settings/mail', :label => _("Mail")},
            {:name => 'integration', :partial => 'administers/settings/integration', :label => _("Integration")},
            {:name => 'authentication', :partial => 'administers/settings/authentication', :label => _("Authentication")},
            {:name => 'mapping_providers', :partial => 'administers/settings/mapping_providers', :label => _("Mapping Providers")}
            ]
  end

end