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

class MessageTemplatesController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/message_templates
  # GET rubycampus.local/message_templates.xml
  def index #:nodoc:
    # @message_templates = MessageTemplate.find(:all)
    @message_templates = MessageTemplate.search_for_all_and_paginate(params[:locate], params[:page])

    respond_to do |format|
      format.html # index.html.haml
      # format.xml  { render :xml => @message_templates }
    end
  end

  # GET rubycampus.local/message_templates/1
  # GET rubycampus.local/message_templates/1.xml
  def show #:nodoc:
    @message_template = MessageTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @message_template }
    end
  end

  # GET rubycampus.local/message_templates/new
  # GET rubycampus.local/message_templates/new.xml
  def new #:nodoc:
    @message_template = MessageTemplate.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @message_template }
    end
  end

  # GET rubycampus.local/message_templates/1/edit
  def edit #:nodoc:
    @message_template = MessageTemplate.find(params[:id])
  end

  # POST rubycampus.local/message_templates
  # POST rubycampus.local/message_templates.xml
  def create #:nodoc:
    @message_template = MessageTemplate.new(params[:message_template])

    respond_to do |format|
      if @message_template.save
        flash[:notice] = _("%s was successfully created.") % _("Message Template")
        if params[:create_and_new_button]
          format.html { redirect_to new_message_template_url }
        else
          format.html { redirect_to message_templates_url }
          # format.xml  { render :xml => @message_template, :status => :created, :location => @message_template }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @message_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/message_templates/1
  # PUT rubycampus.local/message_templates/1.xml
  def update #:nodoc:
    @message_template = MessageTemplate.find(params[:id])

    respond_to do |format|
      if @message_template.update_attributes(params[:message_template])
        flash[:notice] = _("%s was successfully updated.") % _("Message Template") 
        format.html { redirect_to message_templates_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @message_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/message_templates/1
  # DELETE rubycampus.local/message_templates/1.xml
  def destroy #:nodoc:
    @message_template = MessageTemplate.find(params[:id])
    @message_template.destroy

    respond_to do |format|
      format.html { redirect_to message_templates_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @message_templates = MessageTemplate.find_for_auto_complete_lookup(params[:search])                            
  end

end