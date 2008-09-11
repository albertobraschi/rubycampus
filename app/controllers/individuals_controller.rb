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

class IndividualsController < ApplicationController 
  before_filter :login_required
  
  # See Contacts Controller  
  # GET rubycampus.local/individuals
  # GET rubycampus.local/individuals.xml
  def index #:nodoc:
  #   @individuals = Contact.search_for_all_and_paginate(params[:search], params[:page], ContactType::INDIVIDUAL)    
  # 
  #   respond_to do |format|
  #     format.html  #index.html.haml
  #     format.xml  # { render :xml => @individuals.contact }
  #   end
  end     

  # GET rubycampus.local/individuals/1
  # GET rubycampus.local/individuals/1.xml
  def show #:nodoc:
    @presenter = IndividualPresenter.new(:contact => Contact.find(params[:id]), 
                                          :address => Address.find(params[:id]),
                                          :email => Email.find(params[:id]),
                                          :messenger => Messenger.find(params[:id]),
                                          :phone => Phone.find(params[:id]))
    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @presenter.contact } 
    end
  end

  def new #:nodoc:
    @presenter = IndividualPresenter.new
  end      
   
  # GET rubycampus.local/individuals/1/edit
  def edit #:nodoc:
    @presenter = IndividualPresenter.new(:contact => Contact.find(params[:id]), 
                                          :address => Address.find(params[:id]),
                                          :email => Email.find(params[:id]),
                                          :messenger => Messenger.find(params[:id]),
                                          :phone => Phone.find(params[:id])) 
  end
  
  # POST rubycampus.local/individuals
  # POST rubycampus.local/individuals.xml  
  def create #:nodoc:                                    
    @presenter = IndividualPresenter.new(params[:presenter])
    @presenter.contact_contact_type_id = ContactType::INDIVIDUAL

    if @presenter.save 
      flash[:notice] = _("%s was successfully created.") % _("Individual")
      if params[:create_and_new_button]
        redirect_to new_individual_url
      else
        redirect_to contacts_url(:contact_type => ContactType::INDIVIDUAL)
      end
    else
      render :action => "new"
    end
  end  
  
  # PUT rubycampus.local/individuals/1
  # PUT rubycampus.local/individuals/1.xml
  def update #:nodoc:
    @presenter = IndividualPresenter.new(:contact => Contact.find(params[:id]), 
                                          :address => Address.find(params[:id]),
                                          :email => Email.find(params[:id]),
                                          :messenger => Messenger.find(params[:id]),
                                          :phone => Phone.find(params[:id]))
                                           
    if @presenter.update_attributes(params[:presenter]) 
      flash[:notice] = _("%s was successfully updated.") % _("Individual")
      redirect_to contacts_url(:contact_type => ContactType::INDIVIDUAL) 
    else
      render :action => "edit"
    end
  end

  # DELETE rubycampus.local/individuals/1
  # DELETE rubycampus.local/individuals/1.xml
  def destroy #:nodoc:
   #@presenter = IndividualPresenter.new(:contact => Contact.find(params[:id]))
    @presenter = Contact.find(params[:id])
    @presenter.destroy

    respond_to do |format| 
      flash[:notice] = _("%s was successfully destroyed.") % _("Individual")
      format.html { redirect_to contacts_url(:contact_type => ContactType::INDIVIDUAL)  }
      format.xml  { head :ok }
    end
  end
  
  # Generates PDF Extract 
  def extract #:nodoc:
    @presenter = IndividualPresenter.new(:contact => Contact.find(params[:id]), 
                                          :address => Address.find(params[:id]),
                                          :email => Email.find(params[:id]),
                                          :messenger => Messenger.find(params[:id]),
                                          :phone => Phone.find(params[:id]))    
    # TODO Generate PDF based on form
    prawnto :inline => true
  end

end