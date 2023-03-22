# frozen_string_literal: true

require_relative 'matrix/generate'
require_relative 'matrix/spec'
require_relative 'matrix/acceptance'

module ModuleMetadata
  module Matrix
    IMAGE_TABLE = {
      'RedHat-7' => 'rhel-7',
      'RedHat-8' => 'rhel-8',
      'RedHat-9' => 'rhel-9',
      'SLES-12' => 'sles-12',
      'SLES-15' => 'sles-15',
      'Windows-2016' => 'windows-2016',
      'Windows-2019' => 'windows-2019',
      'Windows-2022' => 'windows-2022'
    }.freeze

    DOCKER_PLATFORMS = {
      'CentOS-6' => 'litmusimage/centos:6',
      'CentOS-7' => 'litmusimage/centos:7',
      'CentOS-8' => 'litmusimage/centos:stream8', # Support officaly moved to Stream8, metadata is being left as is
      'Rocky-8' => 'litmusimage/rockylinux:8',
      'AlmaLinux-8' => 'litmusimage/almalinux:8',
      'Debian-9' => 'litmusimage/debian:9',
      'Debian-10' => 'litmusimage/debian:10',
      'Debian-11' => 'litmusimage/debian:11',
      'OracleLinux-6' => 'litmusimage/oraclelinux:6',
      'OracleLinux-7' => 'litmusimage/oraclelinux:7',
      'Scientific-6' => 'litmusimage/scientificlinux:6',
      'Scientific-7' => 'litmusimage/scientificlinux:7',
      'Ubuntu-18.04' => 'litmusimage/ubuntu:18.04',
      'Ubuntu-20.04' => 'litmusimage/ubuntu:20.04',
      'Ubuntu-22.04' => 'litmusimage/ubuntu:22.04'
    }.freeze

    # This table uses the latest version in each collection for accurate
    # comparison when evaluating puppet requirements from the metadata
    COLLECTION_TABLE = [
      {
        puppet_maj_version: 7,
        ruby_version: 2.7
      },
      {
        puppet_maj_version: 8,
        ruby_version: 3.2
      }
    ].freeze
  end
end
