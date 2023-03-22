# frozen_string_literal: true

require 'json'
require 'puppet_metadata'

module ModuleMetadata
  module Matrix
    # The Matrix class contains helpers for generating a matrix of platforms and
    # puppet versions to test against.
    class Generator
      def initialize(exclude_platforms = [])
        @exclude_list = exclude_platforms || []
        @acceptance_matrix = AcceptanceMatrix.new
        @spec_matrix = SpecMatrix.new

        metadata_path = ENV['TEST_MATRIX_FROM_METADATA'] || 'metadata.json'
        @metadata = PuppetMetadata.read(metadata_path)
      end

      # Generate the CI matrix for acceptance tests and spec tests
      def generate
        generate_platforms
        generate_collections

        set_output('matrix', @acceptance_matrix.to_s)
        set_output('spec_matrix', @spec_matrix.to_s)

        puts "Created matrix with #{@acceptance_matrix.length + @spec_matrix.length} cells:"
        puts "  - Acceptance Test Cells: #{@acceptance_matrix.length}"
        puts "  - Spec Test Cells: #{@spec_matrix.length}"
      end

      private

      # Return an array of image keys from the metadata
      # @return [Array] An array of image keys from the metadata
      def image_keys
        image_keys = []
        @metadata.operatingsystems.each_key do |os|
          @metadata.operatingsystems[os].each do |release|
            image_keys.append("#{os}-#{release}")
          end
        end
        image_keys
      end

      # Return true if the image_key is in the image table and not in the exclude list
      # @param image_key [String] The image key to check
      # @return [Boolean] True if the image_key is in the image table and not in the exclude list
      def in_image_table?(image_key)
        ModuleMetadata::Matrix::IMAGE_TABLE.key?(image_key) && !@exclude_list.include?(image_key.downcase)
      end

      # Return true if the image_key is in the docker table and not in the exclude list
      # @param image_key [String] The image key to check
      # @return [Boolean] True if the image_key is in the docker table and not in the exclude list
      def in_docker_table?(image_key)
        ModuleMetadata::Matrix::DOCKER_PLATFORMS.key?(image_key) && !@exclude_list.include?(image_key.downcase)
      end

      # Generate the required platforms based on the metadata.json file for
      # acceptance tests.
      def generate_platforms
        image_keys.each do |image_key|
          # Set platforms based on declared operating system support
          if in_image_table?(image_key)
            @acceptance_matrix.add_platform(
              image_key,
              'provision::provision_service',
              ModuleMetadata::Matrix::IMAGE_TABLE[image_key]
            )
            next
          end

          if in_docker_table?(image_key)
            @acceptance_matrix.add_platform(
              image_key,
              'provision::docker',
              ModuleMetadata::Matrix::DOCKER_PLATFORMS[image_key]
            )
            next
          end

          puts "::debug::Cannot find image for #{image_key}" unless @exclude_list.include?(image_key.downcase)
        end
      end

      # Gemerate the required collections based on the metadata.json file
      # for acceptance and spec tests.
      def generate_collections
        ModuleMetadata::Matrix::COLLECTION_TABLE.each do |collection|
          # Test against the "largest" puppet version in a collection, e.g. `7.9999`
          # to allow puppet requirements with a non-zero lower bound on minor/patch versions.
          # This assumes that such a boundary will always allow the latest actually
          # existing puppet version of a release stream, trading off simplicity vs accuracy here.
          version = Gem::Version.new("#{collection[:puppet_maj_version]}.99.99")
          next unless @metadata.satisfies_requirement?('puppet', version.to_s)

          @acceptance_matrix.add_collection("puppet#{collection[:puppet_maj_version]}-nightly")
          @spec_matrix.add_collection("~> #{collection[:puppet_maj_version]}.0", collection[:ruby_version])
        end
      end

      # Sets an output variable in GitHub Actions. If the GITHUB_OUTPUT environment
      # variable is not set, this will fail with an exit code of 1 and
      # send an ::error:: message to the GitHub Actions log.
      # @param name [String] The name of the output variable
      # @param value [String] The value of the output variable
      def set_output(name, value)
        # Get the output path
        output = ENV.fetch('GITHUB_OUTPUT')

        # Write the output variable to GITHUB_OUTPUT
        File.open(output, 'a') do |f|
          f.puts "#{name}=#{value}"
        end
      rescue KeyError
        puts '::error::GITHUB_OUTPUT environment variable not set.'
        exit 1
      end
    end
  end
end
