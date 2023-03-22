# frozen_string_literal: true

require 'json'

module ModuleMetadata
  module Matrix
    # The SpecMatrix class defines the of the matrix used for spec tests
    class SpecMatrix
      attr_accessor :include

      def initialize
        @include = []
      end

      # Add a cell to the matrix
      # @param puppet_maj_version [String] The major version of Puppet
      # @param ruby_version [String] The version of Ruby
      def add_collection(puppet_maj_version, ruby_version)
        @include.append(
          {
            puppet_version: puppet_maj_version,
            ruby_version: ruby_version
          }
        )
      end

      # Return the matrix as a JSON string
      # @return [String] The matrix as a JSON string
      def to_s
        JSON.generate(
          {
            include: @include
          }
        )
      end

      # Return the number of cells in the matrix
      # @return [Integer] The number of cells in the matrix
      def length
        @include.length
      end
    end
  end
end
