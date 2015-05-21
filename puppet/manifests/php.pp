class { 'php':
	service => 'nginx',
}

php::module { ['fpm','cli','mysql']: }
