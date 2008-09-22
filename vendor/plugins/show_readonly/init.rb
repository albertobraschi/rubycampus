#%w[show_readonly includes_helper].each { |file| 
#  require File.join( File.dirname(__FILE__), "lib",file) 
#}
require 'show_readonly'
ActionView::Helpers::FormHelper.send(:include, ShowReadOnly::FormHelper)
ActionView::Base.send(:include, ShowReadOnly::FormHelper)

# install files
#unless File.exists?(RAILS_ROOT + '/public/javascripts/show_readonly/show_readonly.js')
#  ['/public', '/public/javascripts/show_readonly', '/public/stylesheets/show_readonly'].each do |dir|
#    source = File.join(directory,dir)
#    dest = RAILS_ROOT + dir
#    FileUtils.mkdir_p(dest)
#    FileUtils.cp(Dir.glob(source+'/*.*'), dest)
#  end
#end
