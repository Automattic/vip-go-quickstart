class { 'php':
	service => 'nginx',
}

service { 'php5-fpm':
    ensure => running,
    enable => true,
}

php::module { ['fpm','cli','mysql']: } ->
file { '/var/log/php/' :
  ensure => directory,
  owner => www-data, group => www-data, mode => 444,
} ->
file { '/var/log/php/error.log' :
  ensure => present,
  owner => www-data, group => www-data, mode => 644,
} ->
file { '/etc/php5/fpm/conf.d/error.ini' :
  ensure => present,
  notify  => Service['php5-fpm'],
  owner => root, group => root, mode => 644,
  content => "error_log = /var/log/php/error.log\n",
}
