# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "progstr-filer"
  gem.homepage = "http://github.com/progstr/progstr-filer-gem"
  gem.license = "MIT"
  gem.summary = %Q{Progstr Filer API}
  gem.description = %Q{Progstr Filer is a developer-friendly file and attachment hosting service that lets you easily build apps that store and share files.}
  gem.email = "hristo@deshev.com"
  gem.authors = ["Hristo Deshev"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

#require 'rspec/core'
#require 'rspec/core/rake_task'
#RSpec::Core::RakeTask.new(:spec) do |spec|
  #spec.pattern = FileList['spec/**/*_spec.rb']
#end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "filer-gem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
