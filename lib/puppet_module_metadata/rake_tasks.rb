# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require_relative '../puppet_module_metadata'

namespace :metadata do
  namespace :matrix do
    # metadata:matrix:generate task will generate a matrix of supported
    # platforms and ruby versions based on the metadata.json file in the
    # current directory.
    #
    # Platforms can be excluded by passing a space separated list as a parameter.
    #
    # Additionally, the TEST_MATRIX_FROM_METADATA environment variable can be
    # set to a path to a metadata.json file to use instead of the default.
    # @param exclude [Array] An array of platforms to exclude from the matrix
    #
    # @example
    #  rake metadata:matrix:generate
    #
    # @example
    #   rake 'metadata:matrix:generate[centos-7 ubuntu-18.04]''
    desc 'Generate a CI matrix from the metadata.json file.'
    task :generate, [:exclude] do |_task, args|
      generator = ModuleMetadata::Matrix::Generator.new(args[:exclude])
      generator.generate
    end
  end
end
