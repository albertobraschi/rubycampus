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

module DashboardHelper
  def widget_javascript
    <<-EOF
    <script language="JavaScript">
    //<![CDATA[
    function recreateSortables() {
        Sortable.destroy('list-top');
        Sortable.destroy('list-left');
        Sortable.destroy('list-right');
      
      Sortable.create("list-top", {constraint:false, containment:['list-top','list-left','list-right'], dropOnEmpty:true, handle:'handle', onUpdate:function(){new Ajax.Request('/dashboard/order_widgets?group=top', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize("list-top")})}, only:'dashboard-box', tag:'div'})
      Sortable.create("list-left", {constraint:false, containment:['list-top','list-left','list-right'], dropOnEmpty:true, handle:'handle', onUpdate:function(){new Ajax.Request('/dashboard/order_widgets?group=left', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize("list-left")})}, only:'dashboard-box', tag:'div'})
      Sortable.create("list-right", {constraint:false, containment:['list-top','list-left','list-right'], dropOnEmpty:true, handle:'handle', onUpdate:function(){new Ajax.Request('/dashboard/order_widgets?group=right', {asynchronous:true, evalScripts:true, parameters:Sortable.serialize("list-right")})}, only:'dashboard-box', tag:'div'})
    }
    
    function updateSelect() {
        s = $('widget-select')
        for (var i = 0; i < s.options.length; i++) {
            if ($('widget_' + s.options[i].value)) {
                s.options[i].disabled = true;
            } else {
                s.options[i].disabled = false;
            }
        }
        s.options[0].selected = true;
    }
    
    function afterAddBlock() {
        recreateSortables();
        updateSelect();
    }
    
    function removeBlock(widget) {
        Effect.DropOut(widget);
        updateSelect();
    }
    //]]>
    </script>
    EOF
  end
end
