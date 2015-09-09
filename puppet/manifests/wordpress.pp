exec { '/usr/bin/wp --allow-root core download --path="/var/www"':
	cwd     => '/var/www',
	creates => '/var/www/wp-load.php',
	notify  => File['/var/www'],
	user    => 'root',
} ->
exec { 'git clone mu-plugins':
	command => 'git clone https://github.com/Automattic/vip-mu-plugins-public.git mu-plugins',
	cwd     => '/var/www/wp-content',
	creates => '/var/www/wp-content/mu-plugins',
	require => Package['git'],
} ->

# Create the core config
exec { 'wp_core_config':
    command => '/usr/bin/wp --allow-root core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --extra-php <<PHP
define( "DISALLOW_FILE_MODS", true );

if ( file_exists( __DIR__ . "/wp-content/vip-config/vip-config.php" ) )
	require_once( __DIR__ . "/wp-content/vip-config/vip-config.php" );

if ( ! defined( "ABSPATH" ) )
	define( "ABSPATH", dirname( __FILE__ ) . "/" );

PHP',
    path    => '/usr/bin/',
	cwd     => '/var/www',
	creates => '/var/www/wp-config.php',
	user    => 'root',
} ->

exec { 'find /var/www -not -path "*wp-content/themes*" -not -path "*wp-content/plugins*" -print0 | xargs -0 /bin/chown www-data:www-data':
	cwd	=> '/var/www',
	user	=> 'root',
} ->
wp::site { '/var/www':
	url            => 'http://vip.local',
	name           => 'VIP',
	admin_user     => 'wordpress',
	admin_password => 'wordpress',
	require        => Mysql::Db['wordpress']
} ->
exec { '/usr/bin/wp --allow-root plugin delete hello':
        cwd     => '/var/www',
        user    => 'root',
} ->
exec { '/usr/bin/wp --allow-root plugin delete akismet':
        cwd     => '/var/www',
        user    => 'root'
}

# TODO: Update to latest stable
# TODO: Add mu-plugins
# TODO: Add debug plugins

file { '/var/www':
	ensure  => 'directory',
	owner   => 'www-data',
	group   => 'www-data',
}

