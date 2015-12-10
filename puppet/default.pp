Exec { path => '/bin:/usr/bin:/usr/local/bin:/usr/sbin:/sbin' }

import 'manifests/*.pp'

include apt
include apt::update
include apt::backports

Class['apt::update'] -> Package <||>

host { 'vip-go':
    name => $hostname,
    ensure => 'present',
    ip => '127.0.0.1',
}

package { ['git']:
	ensure => present,
}
