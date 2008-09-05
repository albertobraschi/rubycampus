#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship and Fundraising Management for Higher Education          |
# +------------------------------------------------------------------------------------+
# | Copyright (C) 2008 Kevin Aleman, RubyCampus LLC Japan - https://rubycampus.org     |
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
# | You can contact RubyCampus, LLC. at email address info@rubycampus.org.             |
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

  # GET rubycampus.local/activities
  # GET rubycampus.local/activities.xml
  def index
    # @activities = Activity.find(:all)
    @activities = Activity.search_for_all_and_paginate(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.haml
      # format.xml  { render :xml => @activities }
    end
  end

  # GET rubycampus.local/activities/1
  # GET rubycampus.local/activities/1.xml
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @activity }
    end
  end

  # GET rubycampus.local/activities/new
  # GET rubycampus.local/activities/new.xml
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @activity }
    end
  end

  # GET rubycampus.local/activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end

  # POST rubycampus.local/activities
  # POST rubycampus.local/activities.xml
  def create
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
  def update
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
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to activities_url }
      # format.xml  { head :ok }
    end
  end

end