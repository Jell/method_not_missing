require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('test/**/test_*')
end

task(default: :test)
