class { 'mysql::server': }

mysql::db { $quickstart_domain:
	user     => 'wordpress',
	password => 'wordpress',
}
