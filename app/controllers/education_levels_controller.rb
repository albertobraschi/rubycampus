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

class EducationLevelsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/education_levels
  # GET rubycampus.local/education_levels.xml
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

    @total = EducationLevel.count(:conditions => conditions)
    @education_levels_pages, @education_levels = paginate :education_levels, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "education_levels", :layout => false
    end
  end

  # GET rubycampus.local/education_levels/1
  # GET rubycampus.local/education_levels/1.xml
  def show #:nodoc:
    @education_level = EducationLevel.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @education_level }
    end
  end

  # GET rubycampus.local/education_levels/new
  # GET rubycampus.local/education_levels/new.xml
  def new #:nodoc:
    @education_level = EducationLevel.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @education_level }
    end
  end

  # GET rubycampus.local/education_levels/1/edit
  def edit #:nodoc:
    @education_level = EducationLevel.find(params[:id])
  end

  # POST rubycampus.local/education_levels
  # POST rubycampus.local/education_levels.xml
  def create #:nodoc:
    @education_level = EducationLevel.new(params[:education_level])

    respond_to do |format|
      if @education_level.save
        flash[:notice] = I18n.t("{{value}} was successfully created.", :default => "{{value}} was successfully created.", :value => I18n.t("Education Level", :default => "Education Level"))
        if params[:create_and_new_button]
          format.html { redirect_to new_education_level_url }
        else
          format.html { redirect_to education_levels_url }
          # format.xml  { render :xml => @education_level, :status => :created, :location => @education_level }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @education_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/education_levels/1
  # PUT rubycampus.local/education_levels/1.xml
  def update #:nodoc:
    @education_level = EducationLevel.find(params[:id])

    respond_to do |format|
      if @education_level.update_attributes(params[:education_level])
        flash[:notice] = I18n.t("{{value}} was successfully updated.", :default => "{{value}} was successfully updated.", :value => I18n.t("Education Level", :default => "Education Level"))
        format.html { redirect_to education_levels_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @education_level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/education_levels/1
  # DELETE rubycampus.local/education_levels/1.xml
  def destroy #:nodoc:
    @education_level = EducationLevel.find(params[:id])
    @education_level.destroy

    respond_to do |format|
      format.html { redirect_to education_levels_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @education_levels = EducationLevel.find_for_auto_complete_lookup(params[:search])                            
  end
  
  # PUT rubycampus.local/education_levels/1/enable
  def enable #:nodoc:
    @education_level = EducationLevel.find(params[:id])
    if @education_level.update_attribute(:is_enabled, true)
    flash[:notice] = I18n.t("{{name}} enabled.", :default => "{{name}} enabled.", :name => I18n.t("Education Level", :default => "Education Level"))
    else
    flash[:error] = I18n.t("There was a problem enabling this {{name}}.", :default => "There was a problem enabling this {{name}}.", :name => I18n.t("education level", :default => "education level"))
    end
    redirect_to education_levels_url
  end

  # PUT rubycampus.local/education_levels/1/disable
  def disable #:nodoc:
    @education_level = EducationLevel.find(params[:id])
    if @education_level.update_attribute(:is_enabled, false)
    flash[:notice] = I18n.t("{{name}} disabled.", :default => "{{name}} disabled.", :name => I18n.t("Education Level", :default => "Education Level"))
    else
    flash[:error] = I18n.t("There was a problem disabling this {{name}}.", :default => "There was a problem disabling this {{name}}.", :name => I18n.t("education level", :default => "education level"))
    end
    redirect_to education_levels_url
  end

end