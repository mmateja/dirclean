# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dirclean/version'

Gem::Specification.new do |gem|
  gem.name                  = 'dirclean'
  gem.version               = DirClean::VERSION
  gem.date                  = DirClean::DATE
  gem.summary               = 'Utility for cleaning temporary directories'
  gem.description           = 'Command line utility for cleaning files that were not used for some time'
  gem.authors               = ['Marek Mateja']
  gem.email                 = 'matejowy@gmail.com'
  gem.homepage              = 'https://github.com/mmateja/dirclean'
  gem.license               = 'MIT'
  gem.require_paths         = ['lib']
  gem.required_ruby_version = '>= 2.3'
  gem.executables << 'dirclean'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
end
