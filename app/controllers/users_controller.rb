#--                                                  /THIS FILE IS A PART OF RUBYCAMPUS/
# +------------------------------------------------------------------------------------+
# | RubyCampus - Relationship and Fundraising Management for Higher Education          |
# +------------------------------------------------------------------------------------+
# | Copyright (C) 2008 Kevin Aleman, RubyCampus LLC Japan - https://rubycampus.org     |
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
# | You can contact RubyCampus, LLC. at email address info@rubycampus.org.             |
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

class UsersController < ApplicationController      
  before_filter :not_logged_in_required, :only => [:new, :create]
  before_filter :login_required, :only => [:show, :edit, :update]
  before_filter :check_super_user_role, :only => [:index, :destroy, :enable]
  
  def index
    @users = User.search(params[:search],params[:page])
  end

  # this show action only allows users to view their own profile
  def show
    @user = current_user
  end

  # render new.rhtml
  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.save!
    # Uncomment to have the user automatically
    # logged in after creating an account - Not Recommended
    # self.current_user = @user
    flash[:notice] = _("Thanks for signing up! Please check your email to activate your account before logging in.")
    redirect_to login_path
    rescue ActiveRecord::RecordInvalid
    flash[:error] = _("There was a problem creating your account.")
    render :action => 'new'
  end

  def edit
  @user = current_user
  end

  def update
    @user = User.find(current_user)
    if @user.update_attributes(params[:user])
    flash[:notice] = _("User updated")
    redirect_to :action => 'show', :id => current_user
    else
    render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
    flash[:notice] = _("User disabled")
    else
    flash[:error] = _("There was a problem disabling this user.")
    end
    redirect_to :action => 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
    flash[:notice] = _("User enabled")
    else
    flash[:error] = _("There was a problem enabling this user.")
    end
    redirect_to :action => 'index'
  end

  def activate
    @user = User.find_by_activation_code(params[:id])
    if @user and @user.activate
    self.current_user = @user
    redirect_back_or_default(:controller => '/user_account', :action => 'index')
    flash[:notice] = _("Your account has been activated.")
    end
    redirect_to :action => 'index' 
  end             

end