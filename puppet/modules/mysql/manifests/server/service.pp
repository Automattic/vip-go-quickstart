#
class mysql::server::service {

  if $mysql::server::real_service_manage {
    if $mysql::server::real_service_enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  file { $mysql::params::log_error:
    ensure => present,
    owner  => 'mysql',
    group  => 'mysql',
  }

  service { 'mysqld':
    ensure   => $service_ensure,
    name     => $mysql::server::service_name,
    enable   => $mysql::server::real_service_enabled,
    provider => $mysql::server::service_provider,
    require  => [ File['mysql-config-file'], Package['mysql-server'] ]
  }

}
