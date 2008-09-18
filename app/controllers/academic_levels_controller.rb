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

class AcademicLevelsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/academic_levels
  # GET rubycampus.local/academic_levels.xml
  def index #:nodoc:
    # @academic_levels = AcademicLevel.find(:all)
    @academic_levels = AcademicLevel.search_for_all_and_paginate(params[:locate], params[:page])

    respond_to do |format|
      format.html # index.html.haml
      # format.xml  { render :xml => @academic_levels }
    end
  end

  # GET rubycampus.local/academic_levels/1
  # GET rubycampus.local/academic_levels/1.xml
  def show #:nodoc:
    @academic_level = AcademicLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @academic_level }
    end
  end

  # GET rubycampus.local/academic_levels/new
  # GET rubycampus.local/academic_levels/new.xml
  def new #:nodoc:
    @academic_level = AcademicLevel.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @academic_level }
    end
  end

  # GET rubycampus.local/academic_levels/1/edit
  def edit #:nodoc:
    @academic_level = AcademicLevel.find(params[:id])
  end

  # POST rubycampus.local/academic_levels
  # POST rubycampus.local/academic_levels.xml
  def create #:nodoc:
    @academic_level = AcademicLevel.new(params[:academic_level])

    respond_to do |format|
      if @academic_level.save
        flash[:notice] = _("%s was successfully created.") % _("Academic Level")
        if params[:create_and_new_button]
          format.html { redirect_to new_academic_level_url }
        else
          format.html { redirect_to academic_levels_url }
          # format.xml  { render :xml => @academic_level, :status => :created, :location => @academic_level }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @academic_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/academic_levels/1
  # PUT rubycampus.local/academic_levels/1.xml
  def update #:nodoc:
    @academic_level = AcademicLevel.find(params[:id])

    respond_to do |format|
      if @academic_level.update_attributes(params[:academic_level])
        flash[:notice] = _("%s was successfully updated.") % _("Academic Level") 
        format.html { redirect_to academic_levels_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @academic_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/academic_levels/1
  # DELETE rubycampus.local/academic_levels/1.xml
  def destroy #:nodoc:
    @academic_level = AcademicLevel.find(params[:id])
    @academic_level.destroy

    respond_to do |format|
      format.html { redirect_to academic_levels_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @academic_levels = AcademicLevel.find_for_auto_complete_lookup(params[:search])                            
  end

end