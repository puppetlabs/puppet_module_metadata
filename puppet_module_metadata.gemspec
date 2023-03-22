# frozen_string_literal: true

require_relative 'lib/puppet_module_metadata/version'

Gem::Specification.new do |spec|
  spec.name = 'puppet_module_metadata'
  spec.version = PuppetModuleMetadata::VERSION
  spec.authors = ['Puppet, Inc']
  spec.email = ['info@puppet.com']

  spec.summary = 'A useful library for working with Puppet module metadata.json files'
  spec.description = 'A useful library for working with Puppet module metadata.json files'
  spec.homepage = 'https://puppet.com'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/puppetlabs/puppet_module_metadata'
  spec.metadata['changelog_uri'] = 'https://github.com/puppetlabs/puppet_module_metadata/blob/main/CHANGELOG.md'

  spec.files = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
  ]

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'puppet_metadata', '~> 2.0'
end
