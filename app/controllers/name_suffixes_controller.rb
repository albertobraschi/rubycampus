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

class NameSuffixesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/name_suffixes
  # GET rubycampus.local/name_suffixes.xml
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

    @total = NameSuffix.count(:conditions => conditions)
    @name_suffixes_pages, @name_suffixes = paginate :name_suffixes, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "name_suffixes", :layout => false
    end
  end

  # GET rubycampus.local/name_suffixes/1
  # GET rubycampus.local/name_suffixes/1.xml
  def show #:nodoc:
    @name_suffix = NameSuffix.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @name_suffix }
    end
  end

  # GET rubycampus.local/name_suffixes/new
  # GET rubycampus.local/name_suffixes/new.xml
  def new #:nodoc:
    @name_suffix = NameSuffix.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @name_suffix }
    end
  end

  # GET rubycampus.local/name_suffixes/1/edit
  def edit #:nodoc:
    @name_suffix = NameSuffix.find(params[:id])
  end

  # POST rubycampus.local/name_suffixes
  # POST rubycampus.local/name_suffixes.xml
  def create #:nodoc:
    @name_suffix = NameSuffix.new(params[:name_suffix])

    respond_to do |format|
      if @name_suffix.save
        flash[:notice] = _("%s was successfully created.") % _("Name Suffix")
        if params[:create_and_new_button]
          format.html { redirect_to new_name_suffix_url }
        else
          format.html { redirect_to name_suffixes_url }
          # format.xml  { render :xml => @name_suffix, :status => :created, :location => @name_suffix }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @name_suffix.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/name_suffixes/1
  # PUT rubycampus.local/name_suffixes/1.xml
  def update #:nodoc:
    @name_suffix = NameSuffix.find(params[:id])

    respond_to do |format|
      if @name_suffix.update_attributes(params[:name_suffix])
        flash[:notice] = _("%s was successfully updated.") % _("Name Suffix") 
        format.html { redirect_to name_suffixes_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @name_suffix.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/name_suffixes/1
  # DELETE rubycampus.local/name_suffixes/1.xml
  def destroy #:nodoc:
    @name_suffix = NameSuffix.find(params[:id])
    @name_suffix.destroy

    respond_to do |format|
      format.html { redirect_to name_suffixes_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @name_suffixes = NameSuffix.find_for_auto_complete_lookup(params[:search])                            
  end

end