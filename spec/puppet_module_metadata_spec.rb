# frozen_string_literal: true

require 'rspec'
require 'tempfile'

# rubocop:disable Metrics/BlockLength
RSpec.describe ModuleMetadata::Matrix::Generator do
  before(:all) do
    ENV['TEST_MATRIX_FROM_METADATA'] = 'spec/fixtures/fake_metadata.json'
  end

  context 'without arguments' do
    subject(:generator) { described_class.new }

    let(:github_output) { Tempfile.new('github_output') }
    let(:github_output_content) { github_output.read }

    before(:each) do
      ENV['GITHUB_OUTPUT'] = github_output.path
    end

    let(:expected_stdout) do
      <<~OUTPUT
        ::debug::Cannot find image for Ubuntu-14.04
        Created matrix with 8 cells:
          - Acceptance Test Cells: 6
          - Spec Test Cells: 2
      OUTPUT
    end

    it 'generates a matrix' do
      expect { generator.generate }.to output(expected_stdout).to_stdout

      expect(github_output_content).to include(
        [
          'matrix={',
          '"platforms":[',
          '{"label":"CentOS-6","provider":"provision::docker","image":"litmusimage/centos:6"},',
          '{"label":"RedHat-8","provider":"provision::provision_service","image":"rhel-8"},',
          '{"label":"Ubuntu-18.04","provider":"provision::docker","image":"litmusimage/ubuntu:18.04"}',
          '],',
          '"collection":[',
          '"puppet7-nightly","puppet8-nightly"',
          ']',
          '}'
        ].join
      )

      expect(github_output_content).to include(
        'spec_matrix={"include":[{"puppet_version":"~> 7.0","ruby_version":2.7},{"puppet_version":"~> 8.0","ruby_version":3.2}]}' # rubocop:disable Layout/LineLength
      )
    end
  end

  context 'with exclude list' do
    subject(:generator) { described_class.new(%w[centos-6 redhat-8]) }

    let(:github_output) { Tempfile.new('github_output') }
    let(:github_output_content) { github_output.read }

    before(:each) do
      ENV['GITHUB_OUTPUT'] = github_output.path
    end

    let(:expected_stdout) do
      <<~OUTPUT
        ::debug::Cannot find image for Ubuntu-14.04
        Created matrix with 4 cells:
          - Acceptance Test Cells: 2
          - Spec Test Cells: 2
      OUTPUT
    end

    it 'generates a matrix' do
      expect { generator.generate }.to output(expected_stdout).to_stdout

      expect(github_output_content).to include(
        [
          'matrix={',
          '"platforms":[',
          '{"label":"Ubuntu-18.04","provider":"provision::docker","image":"litmusimage/ubuntu:18.04"}',
          '],',
          '"collection":[',
          '"puppet7-nightly","puppet8-nightly"',
          ']',
          '}'
        ].join
      )

      expect(github_output_content).to include(
        'spec_matrix={"include":[{"puppet_version":"~> 7.0","ruby_version":2.7},{"puppet_version":"~> 8.0","ruby_version":3.2}]}' # rubocop:disable Layout/LineLength
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
