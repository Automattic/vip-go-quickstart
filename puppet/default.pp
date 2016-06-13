Exec { path => '/bin:/usr/bin:/usr/local/bin:/usr/sbin:/sbin' }

import 'manifests/*.pp'

include apt
include apt::update
include apt::backports

# Make sure apt-get is up-to-date before we do anything else
stage { 'updates': before => Stage['main'] }
class { 'updates': stage  => updates }

# updates
class updates {
	exec { 'apt-get update':
		command   => 'apt-get update --quiet --yes',
		timeout => 0
	}
}

host { 'vip-go':
    name => $hostname,
    ensure => 'present',
    ip => '127.0.0.1',
}

package { ['git']:
	ensure => present,
}
