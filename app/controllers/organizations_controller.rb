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

class OrganizationsController < ApplicationController
  before_filter :login_required

  def index #:nodoc:
    sort = case params['sort']
           when "organization_name"  then "organization_name"
           when "organization_name_reverse"  then "organization_name DESC"
           when "updated_at"  then "updated_at"
           when "updated_at_reverse"  then "updated_at DESC"
           end

    conditions = ["contact_type_id = ?", ContactType::ORGANIZATION.id] unless !params[:query].nil?
    conditions = ["organization_name LIKE ? AND contact_type_id = ?", "%#{params[:query]}%", ContactType::ORGANIZATION.id] unless params[:query].nil?

    @total = Contact.count(:conditions => conditions)
    @contacts_pages, @contacts = paginate :contacts, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "organizations", :layout => false
    end
  end

  # GET rubycampus.local/organizations/1
  # GET rubycampus.local/organizations/1.xml
  def show #:nodoc:
    @presenter = OrganizationPresenter.new(:contact => Contact.find(params[:id]),
                                             :address => Address.find(params[:id]),
                                             :email => Email.find(params[:id]),
                                             :messenger => Messenger.find(params[:id]),
                                             :phone => Phone.find(params[:id]))
    @form_id = "edit_organization_"+params[:id]
    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @presenter.contact }
    end
  end

  def new #:nodoc:
    @presenter = OrganizationPresenter.new
  end

  # GET rubycampus.local/organizations/1/edit
  def edit #:nodoc:
    @presenter = OrganizationPresenter.new(:contact => Contact.find(params[:id]),
                                             :address => Address.find(params[:id]),
                                             :email => Email.find(params[:id]),
                                             :messenger => Messenger.find(params[:id]),
                                             :phone => Phone.find(params[:id]))
  end

  # POST rubycampus.local/organizations
  # POST rubycampus.local/organizations.xml
  def create #:nodoc:
    @presenter = OrganizationPresenter.new(params[:presenter])
    @presenter.contact_contact_type_id = ContactType::ORGANIZATION.id

    # TODO There is no nil method available for params to use ||= operator
    begin
    @presenter.contact_group_ids = params[:contact_groups][:group_ids]
    rescue
    @presenter.contact_group_ids = []
    end

    if @presenter.save
      flash[:notice] = _("%s was successfully created.") % _("Organization")
      if params[:create_and_new_button]
        redirect_to new_organization_url
      else
        redirect_to contacts_url(:contact_type => ContactType::ORGANIZATION.id)
      end
    else
      render :action => "new"
    end
  end

  # PUT rubycampus.local/organizations/1
  # PUT rubycampus.local/organizations/1.xml
  def update #:nodoc:
    @presenter = OrganizationPresenter.new(:contact => Contact.find(params[:id]),
                                             :address => Address.find(params[:id]),
                                             :email => Email.find(params[:id]),
                                             :messenger => Messenger.find(params[:id]),
                                             :phone => Phone.find(params[:id]))

    # TODO There is no nil method available for params to use ||= operator
    begin
    @presenter.contact_group_ids = params[:contact_groups][:group_ids]
    rescue
    @presenter.contact_group_ids = []
    end

    if @presenter.update_attributes(params[:presenter])
      flash[:notice] = _("%s was successfully updated.") % _("Organization")
      redirect_to contacts_url(:contact_type => ContactType::ORGANIZATION.id)
    else
      render :action => "edit"
    end
  end

  # DELETE rubycampus.local/organizations/1
  # DELETE rubycampus.local/organizations/1.xml
  def destroy #:nodoc:
    @presenter = Contact.find(params[:id])
    @presenter.destroy

    respond_to do |format|
      flash[:notice] = _("%s was successfully destroyed.") % _("Organization")
      format.html { redirect_to contacts_url(:contact_type => ContactType::ORGANIZATION.id) }
      format.xml  { head :ok }
    end
  end

  # Generates PDF Extract
  def extract #:nodoc:
    @presenter = OrganizationPresenter.new(:contact => Contact.find(params[:id]),
                                             :address => Address.find(params[:id]),
                                             :email => Email.find(params[:id]),
                                             :messenger => Messenger.find(params[:id]),
                                             :phone => Phone.find(params[:id]))
    # TODO Generate PDF based on form
    prawnto :inline => true
  end

end