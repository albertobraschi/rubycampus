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

class PhoneTypesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/phone_types
  # GET rubycampus.local/phone_types.xml
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           when "is_default"  then "is_default"
           when "is_default_reverse"  then "is_default DESC"
           when "is_enabled"  then "is_default"
           when "is_enabled_reverse"  then "is_enabled DESC"
           when "is_reserved"  then "is_reserved"
           when "is_reserved_reverse"  then "is_reserved DESC"
           when "description"  then "description"
           when "description_reverse"  then "description DESC"
           end

    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = PhoneType.count(:conditions => conditions)
    @phone_types_pages, @phone_types = paginate :phone_types, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "phone_types", :layout => false
    end
  end

  # GET rubycampus.local/phone_types/1
  # GET rubycampus.local/phone_types/1.xml
  def show #:nodoc:
    @phone_type = PhoneType.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @phone_type }
    end
  end

  # GET rubycampus.local/phone_types/new
  # GET rubycampus.local/phone_types/new.xml
  def new #:nodoc:
    @phone_type = PhoneType.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @phone_type }
    end
  end

  # GET rubycampus.local/phone_types/1/edit
  def edit #:nodoc:
    @phone_type = PhoneType.find(params[:id])
  end

  # POST rubycampus.local/phone_types
  # POST rubycampus.local/phone_types.xml
  def create #:nodoc:
    @phone_type = PhoneType.new(params[:phone_type])

    respond_to do |format|
      if @phone_type.save
        flash[:notice] = _("%s was successfully created.") % _("Phone Type")
        if params[:create_and_new_button]
          format.html { redirect_to new_phone_type_url }
        else
          format.html { redirect_to phone_types_url }
          # format.xml  { render :xml => @phone_type, :status => :created, :location => @phone_type }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @phone_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/phone_types/1
  # PUT rubycampus.local/phone_types/1.xml
  def update #:nodoc:
    @phone_type = PhoneType.find(params[:id])

    respond_to do |format|
      if @phone_type.update_attributes(params[:phone_type])
        flash[:notice] = _("%s was successfully updated.") % _("Phone Type") 
        format.html { redirect_to phone_types_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @phone_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/phone_types/1
  # DELETE rubycampus.local/phone_types/1.xml
  def destroy #:nodoc:
    @phone_type = PhoneType.find(params[:id])
    @phone_type.destroy

    respond_to do |format|
      format.html { redirect_to phone_types_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @phone_types = PhoneType.find_for_auto_complete_lookup(params[:search])                            
  end
  
  # PUT rubycampus.local/phone_types/1/enable
  def enable #:nodoc:
    @phone_type = PhoneType.find(params[:id])
    if @phone_type.update_attribute(:is_enabled, true)
    flash[:notice] = _("%{name} enabled.") % { :name => _("Phone Type") }
    else
    flash[:error] = _("There was a problem enabling this %{name}.") % { :name => _("phone type") }
    end
    redirect_to phone_types_url
  end

  # PUT rubycampus.local/phone_types/1/disable
  def disable #:nodoc:
    @phone_type = PhoneType.find(params[:id])
    if @phone_type.update_attribute(:is_enabled, false)
    flash[:notice] = _("%{name} disabled.") % { :name => _("Phone Type") }
    else
    flash[:error] = _("There was a problem disabling this %{name}.") % { :name => _("phone type") }
    end
    redirect_to phone_types_url
  end

end