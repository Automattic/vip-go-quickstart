class { 'mysql::server': }

mysql::db { $client:
	user     => 'wordpress',
	password => 'wordpress',
}
