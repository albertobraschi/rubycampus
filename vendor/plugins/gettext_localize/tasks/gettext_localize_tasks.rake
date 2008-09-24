namespace :gettext do

  desc "Update app pot/po files."
  task :updatepo => :environment do
    require 'gettext/utils' 
    require 'haml_parser'
    # Tell ruby-gettext's ErbParser to parse .erb files as well
    # See also http://zargony.com/2007/07/29/using-ruby-gettext-with-edge-rails/
    GetText::ErbParser.init(:extnames => ['.rhtml', '.erb'])
    name = GettextLocalize::app_name
    version = GettextLocalize::app_name_version
    GetText.update_pofiles(name, Dir.glob("{app,lib,bin}/**/*.{rb,rpdf,rhtml,erb,rjs,haml}"), version)
  end

  desc "Create app mo files"
  task :makemo => :environment do
    require 'gettext/utils'
    GetText.create_mofiles(true, "po", "locale")
  end

  namespace :plugins do

    desc "Update pot/po files of all plugins."
    task :updatepo => :environment do
      require 'gettext/utils'
      require 'haml_parser'
      # Tell ruby-gettext's ErbParser to parse .erb files as well
      # See also http://zargony.com/2007/07/29/using-ruby-gettext-with-edge-rails/
      GetText::ErbParser.init(:extnames => ['.rhtml', '.erb'])
      GettextLocalize::each_plugin do |version,name,dir|
        version = name.to_s+" "+version.to_s
        GetText.update_pofiles(name, Dir.glob("#{dir}/**/*.{rb,rpdf,rhtml,erb,rjs,haml}"), version, File.join(dir,"po"))
      end
    end

    desc "Create mo files of all plugins."
    task :makemo => :environment do
      require 'gettext/utils'
      GettextLocalize::each_plugin do |version,name,dir|
        GetText.create_mofiles(true, File.join(dir,"po"), File.join(dir,"locale"))
      end
    end

  end
end
