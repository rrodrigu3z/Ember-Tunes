require "./lib/init"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/*_test.rb"]
end

task :default => :test

load 'barista/tasks/barista.rake'

desc "Start server"
task :server do
  system "rackup config.ru"
end

desc "IRB console"
task :console do
  exec "irb -Ilib -rinit"
end

task :environment do  
end