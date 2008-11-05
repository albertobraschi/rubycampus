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

class MaritalStatusesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/marital_statuses
  # GET rubycampus.local/marital_statuses.xml
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

    @total = MaritalStatus.count(:conditions => conditions)
    @marital_statuses_pages, @marital_statuses = paginate :marital_statuses, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "marital_statuses", :layout => false
    end
  end

  # GET rubycampus.local/marital_statuses/1
  # GET rubycampus.local/marital_statuses/1.xml
  def show #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @marital_status }
    end
  end

  # GET rubycampus.local/marital_statuses/new
  # GET rubycampus.local/marital_statuses/new.xml
  def new #:nodoc:
    @marital_status = MaritalStatus.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @marital_status }
    end
  end

  # GET rubycampus.local/marital_statuses/1/edit
  def edit #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])
  end

  # POST rubycampus.local/marital_statuses
  # POST rubycampus.local/marital_statuses.xml
  def create #:nodoc:
    @marital_status = MaritalStatus.new(params[:marital_status])

    respond_to do |format|
      if @marital_status.save
        flash[:notice] = _("%s was successfully created.") % _("Marital Status")
        if params[:create_and_new_button]
          format.html { redirect_to new_marital_status_url }
        else
          format.html { redirect_to marital_statuses_url }
          # format.xml  { render :xml => @marital_status, :status => :created, :location => @marital_status }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @marital_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/marital_statuses/1
  # PUT rubycampus.local/marital_statuses/1.xml
  def update #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])

    respond_to do |format|
      if @marital_status.update_attributes(params[:marital_status])
        flash[:notice] = _("%s was successfully updated.") % _("Marital Status") 
        format.html { redirect_to marital_statuses_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @marital_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/marital_statuses/1
  # DELETE rubycampus.local/marital_statuses/1.xml
  def destroy #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])
    @marital_status.destroy

    respond_to do |format|
      format.html { redirect_to marital_statuses_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @marital_statuses = MaritalStatus.find_for_auto_complete_lookup(params[:search])                            
  end
  
  # PUT rubycampus.local/marital_statuses/1/enable
  def enable #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])
    if @marital_status.update_attribute(:is_enabled, true)
    flash[:notice] = _("%{name} enabled.") % { :name => _("Marital Status") }
    else
    flash[:error] = _("There was a problem enabling this %{name}.") % { :name => _("marital status") }
    end
    redirect_to marital_statuses_url
  end

  # PUT rubycampus.local/marital_statuses/1/disable
  def disable #:nodoc:
    @marital_status = MaritalStatus.find(params[:id])
    if @marital_status.update_attribute(:is_enabled, false)
    flash[:notice] = _("%{name} disabled.") % { :name => _("Marital Status") }
    else
    flash[:error] = _("There was a problem disabling this %{name}.") % { :name => _("marital status") }
    end
    redirect_to marital_statuses_url
  end

end