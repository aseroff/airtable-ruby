# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'airtable/version'

Gem::Specification.new do |spec|
  spec.name          = 'airtable'
  spec.version       = Airtable::VERSION
  spec.authors       = ['Andrew Seroff', 'Nathan Esquenazi', 'Alexander Sorokin']
  spec.email         = ['andy@seroff.co']
  spec.summary       = 'Easily connect to airtable data using ruby'
  spec.description   = 'Easily connect to airtable data using ruby with access to all of the airtable features.'
  spec.homepage      = 'https://github.com/aseroff/airtable-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'
  spec.add_dependency 'activesupport', '>= 3.0'
  spec.add_dependency 'httparty', '>= 0.14.0'
  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'minitest', '~> 5.6.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-md'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'webmock', '~> 2.1.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
