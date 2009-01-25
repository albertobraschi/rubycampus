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

class UserMailer < ActionMailer::Base

  def new_user_notification(user)
    setup_email(user)
    begin
      body = MailingMixin.find_by_mailing_mixin_type_id(MailingMixinType::NEW_USER_NOTIFICATION.id)
      @subject = body.subject % tokens(user)
      @body[:message] = body.text % tokens(user)
    rescue
      nil
    end
  end

  def activation(user)
    setup_email(user)
    begin
      body = MailingMixin.find_by_mailing_mixin_type_id(MailingMixinType::ACTIVATION.id)
      @subject = body.subject % tokens(user)
      @body[:message] = body.text % tokens(user)
    rescue
      nil
    end
  end

  def forgot_password(user)
    setup_email(user)
    begin
      body = MailingMixin.find_by_mailing_mixin_type_id(MailingMixinType::FORGOT_PASSWORD.id)
      @subject = body.subject % tokens(user)
      @body[:message] = body.text % tokens(user)
    rescue
      nil
    end
  end

  def reset_password(user)
    setup_email(user)
    begin
      body = MailingMixin.find_by_mailing_mixin_type_id(MailingMixinType::RESET_PASSWORD.id)
      @subject = body.subject % tokens(user)
      @body[:message] = body.text % tokens(user)
    rescue
      nil
    end
  end

  protected

  def setup_email(user)
    @recipients = "#{user.email}"
    @from = "#{Setting.site_from_email_address}"
    @subject = I18n.t("{{value}} email setup", :default => "{{value}} email setup", :value => Setting.site_domain)
    @sent_on = Time.now
    @body[:user] = user
  end

  def tokens(user)
    {
     :user_activation_code => "#{Setting.site_protocol}#{Setting.site_domain}/activate/#{user.activation_code}",
     :site_domain => "#{Setting.site_protocol}#{Setting.site_domain}/",
     :user_password_reset_code => "#{Setting.site_protocol}#{Setting.site_domain}/reset_password/#{user.password_reset_code}"
    }
  end

end
