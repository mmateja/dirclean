# frozen_string_literal: true
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = %w(--display-cop-names --format simple)
end
