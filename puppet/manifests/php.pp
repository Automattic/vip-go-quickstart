apt::ppa { 'ppa:ondrej/php': } ->
class { 'php':
	package     => 'php7.0',
	service     => 'nginx',
	config_dir  => '/etc/php/7.0',
	config_file => '/etc/php/7.0/apache2/php.ini',
}

service { 'php7.0-fpm':
    ensure => running,
    enable => true,
}

php::module { ['fpm','cli','mysql']:
	module_prefix => 'php7.0-'
} ->
file { '/var/log/php/' :
  ensure => directory,
  owner => www-data, group => www-data, mode => 444,
} ->
file { '/var/log/php/error.log' :
  ensure => present,
  owner => www-data, group => www-data, mode => 644,
} ->
file { '/etc/php/7.0/fpm/conf.d/error.ini' :
  ensure => present,
  notify  => Service['php7.0-fpm'],
  owner => root, group => root, mode => 644,
  content => "error_log = /var/log/php/error.log\n",
}
