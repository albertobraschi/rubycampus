require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'


desc 'Default: run unit tests.'
task :default => :test

desc 'Test the gettext_localize plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the gettext_localize plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'GettextLocalize'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  desc 'Generate coverage stats for the tests of the gettext_localize plugin.'
  Rcov::RcovTask.new(:rcov) do |rcov|
    rcov.libs << "test"
    rcov.test_files = FileList['test/*test.rb']
    rcov.verbose = true
    rcov.rcov_opts << "--exclude '../app' --exclude '../config' --exclude '../lib'"
  end
rescue
end
