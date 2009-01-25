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

require File.dirname(__FILE__) + '/../spec_helper'

module EntryTermSpecHelper
  def valid_entry_term_attributes
    {
      :code => "FALL2009",
      :name => "Fall 2009",
      :description => "Fall 2009 description.",
      :start_date => "2009-01-01",
      :end_date => "2009-01-02"
    }
  end
end

describe EntryTerm do
  
  include EntryTermSpecHelper
  
  before(:each) do
    @entry_term = EntryTerm.new
  end
  
  it "should be valid" do
    @entry_term.attributes = valid_entry_term_attributes
    @entry_term.should be_valid
  end
  
  it "should require code" do
    @entry_term.should have(1).error_on(:code)
  end
  
  it "should require name" do
    @entry_term.should have(1).error_on(:name)
  end
  
  it "should require description" do
    @entry_term.should have(1).error_on(:description)
  end 
  
  it "should require start date" do
    @entry_term.should have(1).error_on(:start_date)
  end 
  
  it "should require end date" do
    @entry_term.should have(1).error_on(:end_date)
  end
  
end