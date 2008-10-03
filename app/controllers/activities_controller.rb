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

class ActivitiesController < ApplicationController
  before_filter :login_required

  def index #:nodoc:
    sort = case params['sort']
           when "activity_type_id"  then "activity_type_id"
           when "activity_type_id_reverse"  then "activity_type_id DESC"
           when "subject"  then "subject"
           when "subject_reverse"  then "subject DESC"
           when "contact_id"  then "contact_id"
           when "contact_id_reverse"  then "contact_id DESC"
           when "updated_at"  then "updated_at"
           when "updated_at_reverse"  then "updated_at DESC"
           end

    conditions = ["subject LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = Activity.count(:conditions => conditions)
    @activities_pages, @activities = paginate :activities, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "activities", :layout => false
    end
  end

  # GET rubycampus.local/activities/1
  # GET rubycampus.local/activities/1.xml
  def show #:nodoc:
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @activity }
    end
  end

  # GET rubycampus.local/activities/new
  # GET rubycampus.local/activities/new.xml
  def new #:nodoc:
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @activity }
    end
  end

  # GET rubycampus.local/activities/1/edit
  def edit #:nodoc:
    @activity = Activity.find(params[:id])
  end

  # POST rubycampus.local/activities
  # POST rubycampus.local/activities.xml
  def create #:nodoc:
    @activity = Activity.new(params[:activity])

    respond_to do |format|
      if @activity.save
        flash[:notice] = _("%s was successfully created.") % _("Activity")
        if params[:create_and_new_button]
          format.html { redirect_to new_activity_url }
        else
          format.html { redirect_to activities_url }
          # format.xml  { render :xml => @activity, :status => :created, :location => @activity }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/activities/1
  # PUT rubycampus.local/activities/1.xml
  def update #:nodoc:
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        flash[:notice] = _("%s was successfully updated.") % _("Activity") 
        format.html { redirect_to activities_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/activities/1
  # DELETE rubycampus.local/activities/1.xml
  def destroy #:nodoc:
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url }
      # format.xml  { head :ok }
    end
  end

end