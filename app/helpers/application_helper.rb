#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship Management & Alumni Development Software                 |
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

module ApplicationHelper

  # Sets <body class=""> to controllers name for stylesheet hooks
  def body_tag_classes
    @body_tag_classes ||= [ RUBYCAMPUS, controller.controller_name ]
  end

  # Sets title and optionally <body class="">
  def title(page_title,body_tag_klass=nil)
    if !body_tag_klass.nil?
      body_tag_classes << body_tag_klass
    end
    content_for(:title) { page_title }
  end

  #
  # By default, uses the current controller and action to render the url to the
  # corresponding RubyCampus wiki page.
  #
  def link_to_help
    wiki_page = "#{RUBYCAMPUS_ORG_BASE_URL}wiki/#{RUBYCAMPUS}/"
    case controller.action_name.to_s
      when "index"
        wiki_page << "Managing_#{controller.controller_name.titleize}"
      when "show"
        wiki_page << "Viewing_An_Existing_#{controller.controller_name.singularize.titleize}"
      when "new"
        wiki_page << "Creating_A_New_#{controller.controller_name.singularize.titleize}"
      when "edit"
        wiki_page << "Editing_An_Existing_#{controller.controller_name.singularize.titleize}"
      else
        wiki_page << "#{controller.controller_name.titleize}"
      end
    link_to _("Help"), "#{wiki_page}", :popup => true
  end

  # Links to RubyCampus issue tracker and fill basic issue information
  def link_to_tracker_issues_new
    link_to _("New Issue"), RUBYCAMPUS_ORG_BASE_URL + "projects/#{RUBYCAMPUS}/issues/new", :popup => true
  end

  # Get current controllers name
  def current_controller_human_name
    controller.controller_name.singularize.titleize
  end

  def current_controller_gettext_human_name
    _(current_controller_human_name)
  end

  def current_controller_gettext_human_name_pluralized
    _(controller.controller_name.titleize)
  end

  # Returns a constant based on the controllers name singularlized
  def current_controller_contact_type
   eval = controller.controller_name.upcase.singularize
   case
     when eval == "INDIVIDUAL"
       return ContactType::INDIVIDUAL.id
     when eval == "ORGANIZATION"
       return ContactType::ORGANIZATION.id
     when eval == "HOUSEHOLD"
       return ContactType::HOUSEHOLD.id
     else
       return nil
     end
  end

  # Renders links for views
  def link_to_extract
    link_to _("PDF"), { :action => :extract, :id => params[:id], :format => :pdf }, :class => "positive"
  end

  def link_to_edit
    link_to(_("Edit"), self.send(("edit_"+controller.controller_name.singularize+ "_path")), :class => "positive")
  end

  def link_to_destroy
    link_to(_("Destroy"), self.send((controller.controller_name.singularize+ "_path")), :class => "negative", :confirm => (_("Really destroy %s?") % controller.controller_name.titleize), :method => :delete )
  end

  # Returns true if current contact_type evaluates true
  def current_contact_type_is(contact_type)
    params[:contact_type] == contact_type.to_s
  end

  def current_announcements
    @current_announcements ||= Announcement.current_announcements(session[:announcement_hide_time])
  end

  # List available languages
  def language_options_for_select(blank=true)
    require 'yaml'
    language_select = []
    languages = YAML::load_file("#{RAILS_ROOT}/lib/rubycampus/system/languages.yml")
    available_locales.each do |v|
      n = languages[v] || _('Unknown Language')
      language_select << [ n , v ]
    end
    language_select
  end
   
  # Renders hakozaki css class label requiring only the controller name
  #
  # Checks if user is authorized to edit lookup tables and optionally
  # uses :example and :label.
  #
  # :label - overrides the default labeling scheme which uses the controllers name
  # :example - renders a muted notation inline with the label
  #
  # Example:
  #
  # -> label_with_lookup :controller => :name_prefix, :example => _("Fall 2009"), :label => _("Prefix")
  def label_with_lookup(opts={})
    controller = opts[:controller]
    example = opts[:example] || ''
    label = opts[:label] || opts[:controller]
    content_tag(:span, (current_user_is_super_user_role ? (link_to _(label.to_s.titleize), self.send(controller.to_s.underscore.pluralize+"_path")) : _(label.to_s.titleize)) + (content_tag(:span, ' ' + _(example), :class => "example") unless example == nil) , :class => "title")
  end
  
  # Returns true if current_user is_admin and/or has_role of administrator
  def current_user_is_super_user_role
    current_user.is_admin || current_user.has_role?('administrator')
  end
  
  # Returns UL of mergable tokens
  # FIXME Just a mock
  def list_mergable_tokens      
      out = "<ul>"
      for token in TOKENS do
        out << content_tag(:li, token, :style => "list-style-type: none")                        
      end
      out << "</ul>"                  
  end    

end
