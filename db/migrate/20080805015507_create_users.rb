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

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string     :login, :limit => 40 
      t.string     :name, :limit => 100, :default => '', :null => true
      t.string     :cas_user, :limit => 100, :default => '', :null => true
      t.string     :email, :limit => 100
      t.string     :crypted_password, :limit => 40
      t.string     :salt, :limit => 40
      t.string     :remember_token, :limit => 40
      t.datetime   :remember_token_expires_at
      t.string     :activation_code, :limit => 40
      t.string     :password_reset_code, :limit => 40
      t.boolean    :enabled, :default => true   
      t.string     :state, :null => :no, :default => 'passive'
      t.boolean    :is_admin, :default => false
      t.boolean    :is_reserved, :default => false     
      t.string     :time_zone
      t.string     :language, :limit => 5,  :default => 'en', :null => false
      t.integer    :updated_by
      t.datetime   :activated_at
      t.datetime   :deleted_at
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
