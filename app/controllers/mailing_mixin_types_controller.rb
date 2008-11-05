#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship Management & Alumni Development Software                 |
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

class MailingMixinTypesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/mailing_mixin_types
  # GET rubycampus.local/mailing_mixin_types.xml
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           end
  
    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?
  
    @total = MailingMixinType.count(:conditions => conditions)
    @mailing_mixin_types_pages, @mailing_mixin_types = paginate :mailing_mixin_types, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page
  
    if request.xml_http_request?
      render :partial => "mailing_mixin_types", :layout => false
    end
  end 
  
  # GET rubycampus.local/mailing_mixin_types/1
  # GET rubycampus.local/mailing_mixin_types/1.xml
  def show #:nodoc:
    @mailing_mixin_type = MailingMixinType.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @mailing_mixin_type }
    end
  end
  
  # GET rubycampus.local/mailing_mixin_types/new
  # GET rubycampus.local/mailing_mixin_types/new.xml
  def new #:nodoc:
    @mailing_mixin_type = MailingMixinType.new
  
    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @mailing_mixin_type }
    end
  end
  
  # GET rubycampus.local/mailing_mixin_types/1/edit
  def edit #:nodoc:
    @mailing_mixin_type = MailingMixinType.find(params[:id])
  end
  
  # POST rubycampus.local/mailing_mixin_types
  # POST rubycampus.local/mailing_mixin_types.xml
  def create #:nodoc:
    @mailing_mixin_type = MailingMixinType.new(params[:mailing_mixin_type])
  
    respond_to do |format|
      if @mailing_mixin_type.save
        flash[:notice] = _("%s was successfully created.") % _("Mailing Mixin Type")
        if params[:create_and_new_button]
          format.html { redirect_to new_mailing_mixin_type_url }
        else
          format.html { redirect_to mailing_mixin_types_url }
          # format.xml  { render :xml => @mailing_mixin_type, :status => :created, :location => @mailing_mixin_type }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @mailing_mixin_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT rubycampus.local/mailing_mixin_types/1
  # PUT rubycampus.local/mailing_mixin_types/1.xml
  def update #:nodoc:
    @mailing_mixin_type = MailingMixinType.find(params[:id])
  
    respond_to do |format|
      if @mailing_mixin_type.update_attributes(params[:mailing_mixin_type])
        flash[:notice] = _("%s was successfully updated.") % _("Mailing Mixin Type") 
        format.html { redirect_to mailing_mixin_types_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @mailing_mixin_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE rubycampus.local/mailing_mixin_types/1
  # DELETE rubycampus.local/mailing_mixin_types/1.xml
  def destroy #:nodoc:
    @mailing_mixin_type = MailingMixinType.find(params[:id])
    @mailing_mixin_type.destroy
  
    respond_to do |format|
      format.html { redirect_to mailing_mixin_types_url }
      # format.xml  { head :ok }
    end
  end  
  
  def lookup #:nodoc:
    @mailing_mixin_types = MailingMixinType.find_for_auto_complete_lookup(params[:search])                            
  end

end