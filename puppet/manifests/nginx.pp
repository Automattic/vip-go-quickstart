class { nginx: }

nginx::resource::vhost { $client:
	www_root             => '/var/www',
	server_name          => [$hostname],
	index_files          => ['index.php'],
	raw_prepend          => 'try_files $uri $uri/ /index.php;',
	use_default_location => false,
}

nginx::resource::location { 'php':
	location => '~ \.php$',
	vhost    => $client,
	fastcgi  => 'unix:/var/run/php5-fpm.sock',
	fastcgi_param      => {
		'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name',
	}
}

nginx::resource::location { '/_static/':
	vhost   => $client,
	fastcgi => 'unix:/var/run/php5-fpm.sock',
	fastcgi_param => {
		'SCRIPT_FILENAME' => '$document_root/wp-content/mu-plugins/http-concat/ngx-http-concat.php',
	}
}
