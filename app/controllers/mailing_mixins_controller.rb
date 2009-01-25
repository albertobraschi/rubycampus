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

class MailingMixinsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
    
  # GET rubycampus.local/mailing_mixins
  # GET rubycampus.local/mailing_mixins.xml
  def index #:nodoc:
    sort = case params['sort']
           when "name"  then "name"
           when "name_reverse"  then "name DESC"
           when "mailing_mixin_type_id"  then "mailing_mixin_type_id"
           when "mailing_mixin_type_id_reverse"  then "mailing_mixin_type_id DESC"
           when "subject"  then "subject"
           when "subject_reverse"  then "subject DESC"
           when "html"  then "html"
           when "html_reverse"  then "html DESC"
           when "text"  then "text"
           when "text_reverse"  then "text DESC"
           when "is_default"  then "is_default"
           when "is_default_reverse"  then "is_default DESC"
           when "is_enabled"  then "is_enabled"
           when "is_enabled_reverse"  then "is_enabled DESC"
           end

    conditions = ["name LIKE ?", "%#{params[:query]}%"] unless params[:query].nil?

    @total = MailingMixin.count(:conditions => conditions)
    @mailing_mixins_pages, @mailing_mixins = paginate :mailing_mixins, :order => sort, :conditions => conditions, :per_page => AppConfig.rows_per_page

    if request.xml_http_request?
      render :partial => "mailing_mixins", :layout => false
    end
  end 
  
  # GET rubycampus.local/mailing_mixins/1
  # GET rubycampus.local/mailing_mixins/1.xml
  def show #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @mailing_mixin }
    end
  end

  # GET rubycampus.local/mailing_mixins/new
  # GET rubycampus.local/mailing_mixins/new.xml
  def new #:nodoc:
    @mailing_mixin = MailingMixin.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @mailing_mixin }
    end
  end

  # GET rubycampus.local/mailing_mixins/1/edit
  def edit #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])
  end

  # POST rubycampus.local/mailing_mixins
  # POST rubycampus.local/mailing_mixins.xml
  def create #:nodoc:
    @mailing_mixin = MailingMixin.new(params[:mailing_mixin])

    respond_to do |format|
      if @mailing_mixin.save
        flash[:notice] = I18n.t("{{value}} was successfully created.", :default => "{{value}} was successfully created.", :value => I18n.t("Mailing Mixin", :default => "Mailing Mixin"))
        if params[:create_and_new_button]
          format.html { redirect_to new_mailing_mixin_url }
        else
          format.html { redirect_to mailing_mixins_url }
          # format.xml  { render :xml => @mailing_mixin, :status => :created, :location => @mailing_mixin }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @mailing_mixin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/mailing_mixins/1
  # PUT rubycampus.local/mailing_mixins/1.xml
  def update #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])

    respond_to do |format|
      if @mailing_mixin.update_attributes(params[:mailing_mixin])
        flash[:notice] = I18n.t("{{value}} was successfully updated.", :default => "{{value}} was successfully updated.", :value => I18n.t("Mailing Mixin", :default => "Mailing Mixin"))
        format.html { redirect_to mailing_mixins_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @mailing_mixin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/mailing_mixins/1
  # DELETE rubycampus.local/mailing_mixins/1.xml
  def destroy #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])
    @mailing_mixin.destroy

    respond_to do |format|
      format.html { redirect_to mailing_mixins_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @mailing_mixins = MailingMixin.find_for_auto_complete_lookup(params[:search])                            
  end
  
  # PUT rubycampus.local/mailing_mixins/1/enable
  def enable #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])
    if @mailing_mixin.update_attribute(:is_enabled, true)
    flash[:notice] = I18n.t("{{name}} enabled.", :default => "{{name}} enabled.", :name => I18n.t("Mailing Mixin", :default => "Mailing Mixin"))
    else
    flash[:error] = I18n.t("There was a problem enabling this {{name}}.", :default => "There was a problem enabling this {{name}}.", :name => I18n.t("mailing mixin", :default => "mailing mixin"))
    end
    redirect_to mailing_mixins_url
  end
  
  # PUT rubycampus.local/mailing_mixins/1/disable
  def disable #:nodoc:
    @mailing_mixin = MailingMixin.find(params[:id])
    if @mailing_mixin.update_attribute(:is_enabled, false)
    flash[:notice] = I18n.t("{{name}} disabled.", :default => "{{name}} disabled.", :name => I18n.t("Mailing Mixin", :default => "Mailing Mixin"))
    else
    flash[:error] = I18n.t("There was a problem disabling this {{name}}.", :default => "There was a problem disabling this {{name}}.", :name => I18n.t("mailing mixin", :default => "mailing mixin"))
    end
    redirect_to mailing_mixins_url
  end

end