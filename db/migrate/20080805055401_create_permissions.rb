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

class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
    t.integer :role_id, :user_id, :null => false
    t.integer :updated_by
    t.timestamps
    end

    Role.create(:name => 'administrator')
    Role.create(:name => 'supervisor')
    Role.create(:name => 'staff')

    user = User.new
    user.login = "admin"
    user.email = "admin@rubycampus.local"
    user.name = "Administrator"
    user.password = "password"
    user.password_confirmation = "password"
    user.is_admin = true
    user.save(false)
    user.send(:activate!)

    role = Role.find_by_name('administrator')
    user = User.find_by_login('admin')

    permission = Permission.new 
    permission.role_id = role
    permission.user_id = user   
    permission.save(false)      

    user2 = User.new
    user2.login = "supervisor"
    user2.email = "supervisor@rubycampus.local"
    user2.name = "Supervisor"
    user2.password = "password"
    user2.password_confirmation = "password"
    user2.is_admin = false
    user2.save(false)
    user2.send(:activate!)

    role2 = Role.find_by_name('supervisor')
    user2 = User.find_by_login('supervisor')

    permission2 = Permission.new 
    permission2.role_id = role2
    permission2.user_id = user2 
    permission2.save(false)      

    user3 = User.new
    user3.login = "staff"
    user3.email = "staff@rubycampus.local"
    user3.name = "Staff"
    user3.password = "password"
    user3.password_confirmation = "password"
    user3.is_admin = false
    user3.save(false)
    user3.send(:activate!)

    role3 = Role.find_by_name('staff')
    user3 = User.find_by_login('staff')

    permission3 = Permission.new 
    permission3.role_id = role3
    permission3.user_id = user3
    permission3.save(false)      
  end

  def self.down
    drop_table :permissions
    Role.find_by_name('administrator').destroy
    User.find_by_login('admin').destroy   
  end   
end
