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

class GroupsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           when "id"  then "id"
           when "id_reverse"  then "id DESC"
           when "description"  then "description"
           when "description_reverse"  then "description DESC"
           when "is_enabled"  then "is_enabled"
           when "is_enabled_reverse"  then "is_enabled DESC"
           when "group_type_id"  then "group_type_id"
           when "group_type_id_reverse"  then "group_type_id DESC"
           when "updated_at"  then "updated_at"
           when "updated_at_reverse"  then "updated_at DESC"
           end

    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = Group.count(:conditions => conditions)
    @groups_pages, @groups = paginate :groups, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "groups", :layout => false
    end
  end

  # GET rubycampus.local/groups/1
  # GET rubycampus.local/groups/1.xml
  def show #:nodoc:
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @group }
    end
  end

  # GET rubycampus.local/groups/new
  # GET rubycampus.local/groups/new.xml
  def new #:nodoc:
    @group = Group.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @group }
    end
  end

  # GET rubycampus.local/groups/1/edit
  def edit #:nodoc:
    @group = Group.find(params[:id])
  end

  # POST rubycampus.local/groups
  # POST rubycampus.local/groups.xml
  def create #:nodoc:
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = _("%s was successfully created.") % _("Group")
        if params[:create_and_new_button]
          format.html { redirect_to new_group_url }
        else
          format.html { redirect_to groups_url }
          # format.xml  { render :xml => @group, :status => :created, :location => @group }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/groups/1
  # PUT rubycampus.local/groups/1.xml
  def update #:nodoc:
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = _("%s was successfully updated.") % _("Group") 
        format.html { redirect_to groups_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/groups/1
  # DELETE rubycampus.local/groups/1.xml
  def destroy #:nodoc:
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @groups = Group.find_for_auto_complete_lookup(params[:search])                            
  end

end