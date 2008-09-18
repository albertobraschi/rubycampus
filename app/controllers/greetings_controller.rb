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

class GreetingsController < ApplicationController
  before_filter :login_required, :except => [ :lookup ]
  before_filter :check_super_user_role, :except => [ :lookup ]
  
  # GET rubycampus.local/greetings
  # GET rubycampus.local/greetings.xml
  def index #:nodoc:
    # @greetings = Greeting.find(:all)
    @greetings = Greeting.search_for_all_and_paginate(params[:locate], params[:page])

    respond_to do |format|
      format.html # index.html.haml
      # format.xml  { render :xml => @greetings }
    end
  end

  # GET rubycampus.local/greetings/1
  # GET rubycampus.local/greetings/1.xml
  def show #:nodoc:
    @greeting = Greeting.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      # format.xml  { render :xml => @greeting }
    end
  end

  # GET rubycampus.local/greetings/new
  # GET rubycampus.local/greetings/new.xml
  def new #:nodoc:
    @greeting = Greeting.new

    respond_to do |format|
      format.html # new.html.haml
      # format.xml  { render :xml => @greeting }
    end
  end

  # GET rubycampus.local/greetings/1/edit
  def edit #:nodoc:
    @greeting = Greeting.find(params[:id])
  end

  # POST rubycampus.local/greetings
  # POST rubycampus.local/greetings.xml
  def create #:nodoc:
    @greeting = Greeting.new(params[:greeting])

    respond_to do |format|
      if @greeting.save
        flash[:notice] = _("%s was successfully created.") % _("Greeting")
        if params[:create_and_new_button]
          format.html { redirect_to new_greeting_url }
        else
          format.html { redirect_to greetings_url }
          # format.xml  { render :xml => @greeting, :status => :created, :location => @greeting }
        end
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @greeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT rubycampus.local/greetings/1
  # PUT rubycampus.local/greetings/1.xml
  def update #:nodoc:
    @greeting = Greeting.find(params[:id])

    respond_to do |format|
      if @greeting.update_attributes(params[:greeting])
        flash[:notice] = _("%s was successfully updated.") % _("Greeting") 
        format.html { redirect_to greetings_url }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @greeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE rubycampus.local/greetings/1
  # DELETE rubycampus.local/greetings/1.xml
  def destroy #:nodoc:
    @greeting = Greeting.find(params[:id])
    @greeting.destroy

    respond_to do |format|
      format.html { redirect_to greetings_url }
      # format.xml  { head :ok }
    end
  end
  
  def lookup #:nodoc:
    @greetings = Greeting.find_for_auto_complete_lookup(params[:search])                            
  end

end