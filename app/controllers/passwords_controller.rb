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

class PasswordsController < ApplicationController 
  layout 'login'
  before_filter :not_logged_in_required, :only => [:new, :create]

  # Enter email address to recover password
  def new #:nodoc:
  end

  # Forgot password action
  def create #:nodoc:
    return unless request.post?
    if @user = User.find_for_forget(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = _("A password reset link has been sent to your email address.")
      redirect_to login_path
      else
      flash[:notice] = _("Could not find a user with that email address.")
      render :action => 'new'  
    end
  end

  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a user in the database
  # Then if everything checks out, shows the password reset fields
  def edit #:nodoc:
    if params[:id].nil?
      render :action => 'new'
      return    
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
    rescue
    logger.error _("Invalid Reset Code entered.")
    flash[:notice] = _("Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)")
    #redirect_back_or_default('/')
    redirect_to new_user_path    
  end

  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update #:nodoc:
    if params[:id].nil?
    render :action => 'new'
    return
    end
    if params[:password].blank?
    flash[:notice] = _("Password field cannot be blank.")
    render :action => 'edit', :id => params[:id]
    return
    end
    @user = User.find_by_password_reset_code(params[:id]) if params[:id]
    raise if @user.nil?
    return if @user unless params[:password]
    if (params[:password] == params[:password_confirmation])
    #Uncomment and comment lines with @user to have the user logged in after reset - not recommended
    #self.current_user = @user #for the next two lines to work
    #current_user.password_confirmation = params[:password_confirmation]
    #current_user.password = params[:password]
    #@user.reset_password
    #flash[:notice] = current_user.save ? "Password reset" : "Password not reset"
    @user.password_confirmation = params[:password_confirmation]
    @user.password = params[:password]
    @user.reset_password
    flash[:notice] = @user.save ? _("Password reset.") : _("Password not reset.")
    else
    flash[:notice] = _("Password mismatch.")
    render :action => 'edit', :id => params[:id]
    return
    end
    redirect_to login_path
    rescue
    logger.error _("Invalid Reset Code entered")
    flash[:notice] = _("Sorry - That is an invalid password reset code. Please check your code and try again. (Perhaps your email client inserted a carriage return?)")
    redirect_to new_user_path
  end      

end