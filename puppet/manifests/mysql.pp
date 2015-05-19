class { 'mysql::server': }

mysql::db { 'wordpress':
	user     => 'wordpress',
	password => 'wordpress',
}
