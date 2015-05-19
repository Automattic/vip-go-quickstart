# Class: nginx::package::debian
#
# This module manages NGINX package installation on debian based systems
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package::debian(
    $manage_repo    = true,
    $package_name   = 'nginx',
    $package_source = 'nginx',
    $package_ensure = 'present'
  ) {

  $distro = downcase($::operatingsystem)

  package { 'nginx':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if $manage_repo {
    include '::apt'
    Exec['apt_update'] -> Package['nginx']

    case $package_source {
      'nginx', 'nginx-stable': {
        apt::source { 'nginx':
          location   => "http://nginx.org/packages/${distro}",
          repos      => 'nginx',
          key        => '7BD9BF62',
          key_source => 'http://nginx.org/keys/nginx_signing.key',
        }
      }
      'nginx-mainline': {
        apt::source { 'nginx':
          location   => "http://nginx.org/packages/mainline/${distro}",
          repos      => 'nginx',
          key        => '7BD9BF62',
          key_source => 'http://nginx.org/keys/nginx_signing.key',
        }
      }
      'passenger': {
        apt::source { 'nginx':
          location          => 'https://oss-binaries.phusionpassenger.com/apt/passenger',
          repos             => 'main',
          key               => '561F9B9CAC40B2F7',
          key_source        => 'https://oss-binaries.phusionpassenger.com/auto-software-signing-gpg-key.txt',
          required_packages => 'apt-transport-https ca-certificates',
        }

        package { 'passenger':
          ensure  => 'present',
          require => Exec['apt_update'],
        }
        
        if $package_name != 'nginx-extras' {
          warning('You must set $package_name to "nginx-extras" to enable Passenger')
        }
      }
      default: {
        fail("\$package_source must be 'nginx-stable', 'nginx-mainline' or 'passenger'. It was set to '${package_source}'")
      }
    }
  }
}
