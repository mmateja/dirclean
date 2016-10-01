# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
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
  gem.required_ruby_version = '>= 2.0'
  gem.executables << 'dirclean'

  gem.add_development_dependency 'rake', '~> 11.3'
  gem.add_development_dependency 'minitest', '~> 5.9'
  gem.add_development_dependency 'rubocop', '~> 0.43'
end
