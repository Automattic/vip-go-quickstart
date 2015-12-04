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
exec { '[ -f wp-config.php ] && rm wp-config.php || echo 0' :
	cwd => '/var/www',
	user => 'root',
} ->
exec { "/usr/bin/wp --allow-root core config --dbname=${client} --dbuser=wordpress --dbpass=wordpress":
	cwd     => '/var/www',
	creates => '/var/www/wp-config.php',
	user    => 'root',
} ->
exec { 'find /var/www -not -path "*wp-content/themes*" -not -path "*wp-content/plugins*" -print0 | xargs -0 /bin/chown www-data:www-data':
	cwd	=> '/var/www',
	user	=> 'root',
} ->
wp::site { '/var/www':
	url            => "http://${hostname}",
	name           => 'VIP',
	admin_user     => 'wordpress',
	admin_password => 'wordpress',
	require        => Mysql::Db["${client}"]
} ->
exec { '/usr/bin/wp --allow-root plugin delete hello':
        cwd     => '/var/www',
        user    => 'root',
} ->
exec { '/usr/bin/wp --allow-root plugin delete akismet':
        cwd     => '/var/www',
        user    => 'root'
} ->
wp::rewrite { '/%post_id%/%postname%/':
	location => '/var/www',
	require => Wp::Site['/var/www']
} ->
wp::option { 'blogname':
	value => $client,
	location => '/var/www',
	require => Wp::Site['/var/www'],
	ensure => 'equal'
} ->
wp::option { 'blogdescription':
	value => $client_git_repo,
	location => '/var/www',
	require => Wp::Site['/var/www'],
	ensure => 'equal'
} ->
wp::option { 'timezone_string':
	value => 'America/New_York',
	location => '/var/www',
	require => Wp::Site['/var/www'],
	ensure => 'equal'
}

# TODO: Update to latest stable
# TODO: Add mu-plugins
# TODO: Add debug plugins

file { '/var/www':
	ensure  => 'directory',
	owner   => 'www-data',
	group   => 'www-data',
}

