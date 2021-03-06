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

class ContactsController < ApplicationController

  before_filter :login_required
  # before_filter :has_permission?

  # GET /contact
  # GET /contact.xml
  def index #:nodoc:
    @contacts = Contact.search_for_all_and_paginate(params[:search], params[:page], params[:contact_type], params[:stage])

    respond_to do |format|
      format.html # index.haml
      # format.xml  { render :xml => @contacts }
    end
  end

  # GET /contact/1
  # GET /contact/1.xml
  def show #:nodoc:
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.haml
      # format.xml  { render :xml => @contact }
    end
  end

  # GET /contact/new
  # GET /contact/new.xml
  def new #:nodoc:
    @contact = Contact.new

    respond_to do |format|
      format.html # new.haml
      # format.xml  { render :xml => @contact }
    end
  end

  # GET /contact/1/edit
  def edit #:nodoc:
    @contact = Contact.find(params[:id])
  end

  # POST /contact
  # POST /contact.xml
  def create #:nodoc:
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(contact_path(@contact)) }
        # format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact/1
  # PUT /contact/1.xml
  def update #:nodoc:
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(contact_path(@contact)) }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact/1
  # DELETE /contact/1.xml
  def destroy #:nodoc:
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      # format.xml  { head :ok }
    end
  end

  # Used for auto completion for specific views
  def lookup #:nodoc:
    @contacts = Contact.find_for_auto_complete_lookup(params[:search])
  end
end
