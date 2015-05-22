exec { '/usr/bin/wp --allow-root core download --path="/var/www"':
	cwd     => '/var/www',
	creates => '/var/www/wp-load.php',
	notify  => File['/var/www'],
	user    => 'root',
} ->
exec { 'git clone mu-plugins':
	command => 'git clone https://github.com/wpcomvip/mu-plugins.git mu-plugins',
	cwd     => '/var/www/wp-content',
	creates => '/var/www/wp-content/mu-plugins',
	require => Package['git'],
} ->
exec { '/usr/bin/wp --allow-root core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress':
	cwd     => '/var/www',
	creates => '/var/www/wp-config.php',
	user    => 'root',
} ->
wp::site { '/var/www':
	url            => 'http://vip.local',
	name           => 'VIP',
	admin_user     => 'wordpress',
	admin_password => 'wordpress',
	require        => Mysql::Db['wordpress']
}

# TODO: Update to latest stable
# TODO: Add mu-plugins
# TODO: Add debug plugins

file { '/var/www':
	ensure  => 'directory',
	owner   => 'www-data',
	group   => 'www-data',
	recurse => true,
}

