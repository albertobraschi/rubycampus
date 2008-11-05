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

class DashboardController < ApplicationController
  before_filter :login_required

  WIDGETS = { 'activity' => _("Activity"),
              'document' => _("Document"),
              'graph_contacts' => _("Contacts by Type"),
              'graph_individuals_by_ethnicity' => _("Individuals by Ethnicity"),
              'graph_individuals_by_marital_status' => _("Individuals by Marital Status"),
              'graph_stages' => _("Individuals by Enrollment Stage"),
              'my_contacts' => _("My Contacts")
            }.freeze
  DEFAULT_LAYOUT = { 'top' => [''],
                     'left' => ['graph_contacts', 'graph_individuals_by_ethnicity'],
                     'right' => ['graph_stages', 'graph_individuals_by_marital_status']
                   }.freeze
  verify :xhr => true, :session => :page_layout, :only => [:add_widget, :remove_widget, :order_widgets]

  def graph_contacts
    generate_graph(WIDGETS['graph_contacts'])
    for contact_type in ContactType.all_active
      @g.data("#{contact_type.name.titleize}",Contact.count(:conditions => ["contact_type_id = ?", contact_type.id]))
    end
    send_data(@g.to_blob,
                :disposition => 'inline',
                :type => 'image/png',
                :filename => "graph_contacts.png")
  end

  def graph_individuals_by_ethnicity
    generate_graph(WIDGETS['graph_individuals_by_ethnicity'])
    for ethnicity in Ethnicity.all_active
      @g.data("#{ethnicity.name.titleize}",Contact.count(:conditions => ["ethnicity_id = ?", ethnicity.id]))
    end
    send_data(@g.to_blob,
                :disposition => 'inline',
                :type => 'image/png',
                :filename => "graph_contacts.png")
  end

  def graph_individuals_by_marital_status
    generate_graph(WIDGETS['graph_individuals_by_marital_status'])
    for marital_status in MaritalStatus.all_active
      @g.data("#{marital_status.name.titleize}",Contact.count(:conditions => ["marital_status_id = ?", marital_status.id]))
    end
    send_data(@g.to_blob,
                :disposition => 'inline',
                :type => 'image/png',
                :filename => "graph_contacts.png")
  end

  def graph_stages
    generate_graph(WIDGETS['graph_stages'])
    for stage in Stage.all_active
      @g.data("#{stage.name.titleize}",Contact.count(:conditions => ["stage_id = ?", stage.id]))
    end
    send_data(@g.to_blob,
                :disposition => 'inline',
                :type => 'image/png',
                :filename => "graph_stages.png")
  end

  def index
    page
    render :action => 'page'
  end

  def page
    @user = current_user
    @widgets = @user.preference[:my_page_layout] || DEFAULT_LAYOUT
  end

  def page_layout
    @user = current_user
    @widgets = @user.preference[:my_page_layout] || DEFAULT_LAYOUT.dup
    session[:page_layout] = @widgets
    %w(top left right).each {|f| session[:page_layout][f] ||= [] }
    @widget_options = []
    WIDGETS.each {|k, v| @widget_options << [_(v), k]}
  end

  def add_widget
    widget = params[:widget]
    render(:nothing => true) and return unless widget && (WIDGETS.keys.include? widget)
    @user = current_user
    %w(top left right).each {|f| (session[:page_layout][f] ||= []).delete widget }
    session[:page_layout]['top'].unshift widget
    render :partial => "widget", :locals => {:user => @user, :widget_name => widget}
  end

  def remove_widget
    widget = params[:widget]
    %w(top left right).each {|f| (session[:page_layout][f] ||= []).delete widget }
    render :nothing => true
  end

  def order_widgets
    group = params[:group]
    group_items = params["list-#{group}"]
    if group_items and group_items.is_a? Array
      %w(top left right).each {|f|
        session[:page_layout][f] = (session[:page_layout][f] || []) - group_items
      }
      session[:page_layout][group] = group_items
    end
    render :nothing => true
  end

  def page_layout_save
    @user = current_user
    @user.preference[:my_page_layout] = session[:page_layout] if session[:page_layout]
    @user.preference.save
    session[:page_layout] = nil
    redirect_to :action => 'page'
  end

  protected

  def generate_graph(title,size="387x289")
    @g = Gruff::Pie.new(size)
    @g.theme = {:font_color => 'black',
                :colors => %w(orange purple green pink red blue),
                :marker_color => 'blue',
                :background_image => 'lib/rubycampus/assets/rubycampus_chart_background.png'
               }
    @g.font = File.expand_path('lib/fonts/VerilySerifMono.otf', RAILS_ROOT)
    @g.title = _(title)
  end

end
