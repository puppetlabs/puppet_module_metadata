# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require_relative 'lib/puppet_module_metadata/rake_tasks'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new

task default: %i[spec rubocop]
