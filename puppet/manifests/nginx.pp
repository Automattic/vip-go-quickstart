class { nginx: }

nginx::resource::vhost { "${quickstart_domain}":
	www_root             => '/var/www',
	server_name          => [$quickstart_domain],
	index_files          => ['index.php'],
	raw_prepend          => 'try_files $uri $uri/ /index.php;',
	use_default_location => false,
}

nginx::resource::location { 'php':
	location => '~ \.php$',
	vhost    => "${quickstart_domain}",
	fastcgi  => 'unix:/var/run/php5-fpm.sock',
	fastcgi_param      => {
		'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name',
	}
}

nginx::resource::location { '/_static/':
	vhost   => "${quickstart_domain}",
	fastcgi => 'unix:/var/run/php5-fpm.sock',
	fastcgi_param => {
		'SCRIPT_FILENAME' => '$document_root/wp-content/mu-plugins/http-concat/ngx-http-concat.php',
	}
}
