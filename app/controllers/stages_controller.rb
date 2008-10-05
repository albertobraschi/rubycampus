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

class StagesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/stages
  # GET rubycampus.local/stages.xml
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           when "is_default"  then "is_default"
           when "is_default_reverse"  then "is_default DESC"
           when "is_enabled"  then "is_default"
           when "is_enabled_reverse"  then "is_enabled DESC"
           end

    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = Stage.count(:conditions => conditions)
    @stages_pages, @stages = paginate :stages, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "stages", :layout => false
    end
  end

  # GET rubycampus.local/stages/1
  # GET rubycampus.local/stages/1.xml
  def show #:nodoc:
    @stage = Stage.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @stage }
    end
  end

  # GET rubycampus.local/stages/new
  # GET rubycampus.local/stages/new.xml
  def new #:nodoc:
    @stage = Stage.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @stage }
    end
  end

  # GET rubycampus.local/stages/1/edit
  def edit #:nodoc:
    @stage = Stage.find(params[:id])
  end

  # POST rubycampus.local/stages
  # POST rubycampus.local/stages.xml
  def create #:nodoc:
    @stage = Stage.new(params[:stage])

    respond_to do |format|
      if @stage.save
        flash[:notice] = _("%s was successfully created.") % _("Stage")
        if params[:create_and_new_button]
          format.html { redirect_to new_stage_url }
        else
          format.html { redirect_to stages_url }
          # format.xml  { render :xml => @stage, :status => :created, :location => @stage }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/stages/1
  # PUT rubycampus.local/stages/1.xml
  def update #:nodoc:
    @stage = Stage.find(params[:id])

    respond_to do |format|
      if @stage.update_attributes(params[:stage])
        flash[:notice] = _("%s was successfully updated.") % _("Stage") 
        format.html { redirect_to stages_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @stage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/stages/1
  # DELETE rubycampus.local/stages/1.xml
  def destroy #:nodoc:
    @stage = Stage.find(params[:id])
    @stage.destroy

    respond_to do |format|
      format.html { redirect_to stages_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @stages = Stage.find_for_auto_complete_lookup(params[:search])                            
  end

end