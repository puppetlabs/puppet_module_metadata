# frozen_string_literal: true

require 'json'

module ModuleMetadata
  module Matrix
    # The AcceptanceMatrix class defines the of the matrix used for acceptance tests
    class AcceptanceMatrix
      attr_accessor :platforms, :collection

      def initialize
        @platforms = []
        @collection = []
      end

      # Add a platform to the matrix
      # @param label [String] The label of the platform
      # @param provider [String] The provider of the platform
      # @param image [String] The image of the platform
      def add_platform(label, provider, image)
        @platforms.append(
          {
            label: label,
            provider: provider,
            image: image
          }
        )
      end

      # Add a cell to the matrix
      # @param collection [String] The collection of the cell
      def add_collection(collection)
        @collection.append(collection)
      end

      # Return the matrix as a JSON string
      # @return [String] The matrix as a JSON string
      def to_s
        JSON.generate(
          {
            platforms: @platforms,
            collection: @collection
          }
        )
      end

      # Return the number of cells in the matrix
      # @return [Integer] The number of cells in the matrix
      def length
        @platforms.length * @collection.length
      end
    end
  end
end
