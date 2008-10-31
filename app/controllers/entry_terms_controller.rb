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

class EntryTermsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/entry_terms
  # GET rubycampus.local/entry_terms.xml
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           when "code"  then "code"
           when "code_reverse"  then "code DESC"
           when "start_date"  then "start_date"
           when "start_date_reverse"  then "start_date DESC"
           when "end_date"  then "end_date"
           when "end_date_reverse"  then "end_date DESC"
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

    @total = EntryTerm.count(:conditions => conditions)
    @entry_terms_pages, @entry_terms = paginate :entry_terms, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "entry_terms", :layout => false
    end
  end

  # GET rubycampus.local/entry_terms/1
  # GET rubycampus.local/entry_terms/1.xml
  def show #:nodoc:
    @entry_term = EntryTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @entry_term }
    end
  end

  # GET rubycampus.local/entry_terms/new
  # GET rubycampus.local/entry_terms/new.xml
  def new #:nodoc:
    @entry_term = EntryTerm.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @entry_term }
    end
  end

  # GET rubycampus.local/entry_terms/1/edit
  def edit #:nodoc:
    @entry_term = EntryTerm.find(params[:id])
  end

  # POST rubycampus.local/entry_terms
  # POST rubycampus.local/entry_terms.xml
  def create #:nodoc:
    @entry_term = EntryTerm.new(params[:entry_term])

    respond_to do |format|
      if @entry_term.save
        flash[:notice] = _("%s was successfully created.") % _("Entry Term")
        if params[:create_and_new_button]
          format.html { redirect_to new_entry_term_url }
        else
          format.html { redirect_to entry_terms_url }
          # format.xml  { render :xml => @entry_term, :status => :created, :location => @entry_term }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @entry_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/entry_terms/1
  # PUT rubycampus.local/entry_terms/1.xml
  def update #:nodoc:
    @entry_term = EntryTerm.find(params[:id])

    respond_to do |format|
      if @entry_term.update_attributes(params[:entry_term])
        flash[:notice] = _("%s was successfully updated.") % _("Entry Term") 
        format.html { redirect_to entry_terms_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @entry_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/entry_terms/1
  # DELETE rubycampus.local/entry_terms/1.xml
  def destroy #:nodoc:
    @entry_term = EntryTerm.find(params[:id])
    @entry_term.destroy

    respond_to do |format|
      format.html { redirect_to entry_terms_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @entry_terms = EntryTerm.find_for_auto_complete_lookup(params[:search])                            
  end
  
  # PUT rubycampus.local/entry_terms/1/enable
  def enable #:nodoc:
    @entry_term = EntryTerm.find(params[:id])
    if @entry_term.update_attribute(:is_enabled, true)
    flash[:notice] = _("%{name} enabled.") % { :name => _("Entry Term") }
    else
    flash[:error] = _("There was a problem enabling this %{name}.") % { :name => _("entry term") }
    end
    redirect_to entry_terms_url
  end

  # PUT rubycampus.local/entry_terms/1/disable
  def disable #:nodoc:
    @entry_term = EntryTerm.find(params[:id])
    if @entry_term.update_attribute(:is_enabled, false)
    flash[:notice] = _("%{name} disabled.") % { :name => _("Entry Term") }
    else
    flash[:error] = _("There was a problem disabling this %{name}.") % { :name => _("entry term") }
    end
    redirect_to entry_terms_url
  end

end