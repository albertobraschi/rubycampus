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

class AddGeocodableTables < ActiveRecord::Migration
  def self.up
    create_table :geocodes do |t|
      t.decimal    :latitude, :precision => 15, :scale => 12
      t.decimal    :longitude, :precision => 15, :scale => 12
      t.string     :query
      t.string     :street
      t.string     :locality
      t.string     :region
      t.string     :postal_code
      t.string     :country
    end

    add_index :geocodes, [:longitude], :name => :geocodes_longitude_index
    add_index :geocodes, [:latitude], :name => :geocodes_latitude_index
    add_index :geocodes, [:query], :name => :geocodes_query_index, :unique => true

    create_table :geocodings do |t|
      t.integer    :geocodable_id
      t.integer    :geocode_id
      t.string     :geocodable_type
    end

    add_index :geocodings, [:geocodable_type], :name => :geocodings_geocodable_type_index
    add_index :geocodings, [:geocode_id], :name => :geocodings_geocode_id_index
    add_index :geocodings, [:geocodable_id], :name => :geocodings_geocodable_id_index
  end

  def self.down
    drop_table  :geocodes
    drop_table  :geocodings
  end
end
