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

class Announcement < ActiveRecord::Base
  # Excludes model from being included in PO template
  require 'gettext/rails'
  untranslate_all
  
  validates_presence_of :message
  validates_length_of :message, :in => 5..800
  
  validates_datetime :starts_at, :before => Proc.new { |announcement| announcement.ends_at }, 
                       :before_message => _("Start date and time must be now or in the future.")
  validates_datetime :ends_at, :after => Proc.new { |announcement| announcement.starts_at }, 
                       :before_message => _("End date and time must come after the start date and time.")
  
  # validates_presence_of :starts_at
  # validates_presence_of :ends_at    
    
  def self.find_all_and_paginate(page)
    paginate :per_page => AppConfig.rows_per_page, :page => page
  end
  
  def self.current_announcements(hide_time)
    with_scope :find => { :conditions => "starts_at <= now() AND ends_at >= now()" } do
      if hide_time.nil?
        find(:all)
      else
        find(:all, :conditions => ["updated_at > ? OR starts_at > ?", hide_time, hide_time])
      end
    end
  end
end


# == Schema Information
# Schema version: 20081006092209
#
# Table name: rubycampus_announcements
#
#  id         :integer(4)      not null, primary key
#  message    :text            not null
#  starts_at  :datetime        not null
#  ends_at    :datetime        not null
#  created_at :datetime
#  updated_at :datetime
#

