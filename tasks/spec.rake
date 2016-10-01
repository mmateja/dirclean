# frozen_string_literal: true
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name       = 'spec'
  t.options    = '-p'
  t.test_files = FileList['spec/**/*.rb']
end

desc 'Run tests'
