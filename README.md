![VIP Go Quickstart](http://vip.wordpress.com/wp-content/themes/a8c/wpcomvip3/img/illustrations/developmenttools-03.svg)

**THIS PROJECT IS A WORK IN PROGRESS, AND IS NOT YET READY FOR PRODUCTION**

# Overview

VIP Go Quickstart is a local development environment for developers creating and maintaining sites on the WordPress.com VIP Go hosting platform. The goal is to provide developers with an environment that closely mirrors production environment, along with all the tools we recommend developers use.

# How to use VIP Go Quickstart

## Installation

0. Networking requires Zeroconf:
	* OS X: You already have Zeroconf, nothing to do here!
	* Windows: If you have iTunes, you already have this. Otherwise, you need to install [Bonjour](http://support.apple.com/kb/DL999)
	* Ubuntu: Run the following command `sudo apt-get install avahi-dnsconfd`
1. Clone this repository to your local machine
2. Move to VIP Go Quickstart directory
3. Initialize the Vagrant using the included `qs-init.sh` script

`qs-init.sh` arguments:

	* --client: unique slug to distinguish this instance's database instance; alphanumeric and hyphens only
	* --git-repo: clone URL for a Go-structured git repo, based on the [VIP Skeleton](https://github.com/Automattic/vip-skeleton) repo
	* --theme: slug of the theme to activate during initialization
	* --wxr: WordPress export file to import during initialization
	* --up: call `vagrant up` to set up Vagrant for the first time; thereafter, uses `vagrant provision` for faster re-initialization

```
cd ~
git clone https://github.com/wpcomvip/qsv2.git vip-go-qs
cd vip-go-qs
./qs-init.sh --client UNIQUE_SLUG --git-repo GIT_REMOTE [--theme DIRECTORY_NAME] [--wxr WXR_TO_IMPORT] [--up]
```

You'll be prompted for your local machine (aka the “host machine”) password during the booting process of Vagrant as an NFS filesystem is being set up. The NFS filesystem is used for sharing folders from the Go-structured git repository with Vagrant. During the initialization process, the provided git repository is checked out into `./go-client-repo/`. You can access this directory to easily develop from your host machine using your favorite tools, IDE, etc.

## Viewing your WordPress site

Navigate to [go-vip.local](http://go-vip.local) in your browser and you should land on a fresh WordPress site.

## Entering WordPress administration

Once you are able to view the site via browser, you can also visit [go-vip.local/wp-admin](http://go-vip.local/wp-admin) and log in using following credentials:

user: `wordpress`

password: `wordpress`

## Developing themes and plugins

There are two shared folders: `~/vip-quickstart/themes` and `~/vip-quickstart/plugins` which are accessible from both the host and guest (i.e. the Vagrant VM, not the host) machines. All changes are automatically mirrored between the two (host and guest) systems, which means that you can edit files on either system and see the changes live on `vip.local` site.

Those folders are mounted to `/var/www/wp-content/themes` and `/var/www/wp-content/plugins` on the guest machine.

The root directory for WordPress installation on the guest machine is `/var/www` and, once you have your Vagrant running (see above), this directory can be accessed via `vagrant ssh` command:

```bash
vagrant ssh
cd /var/www
```

## Viewing logs

The PHP log is written to `/var/log/nginx/vip.local.error.log` on the guest machine. Once you have your Vagrant running (see above), you can view the log as follows:

```bash
vagrant ssh
less +F /var/log/nginx/vip.local.error.log
```

N.B. The `less +F` command and option starts following the log file in the `less` file viewer, with new lines being appended as they are written to the log. To stop following the log, i.e. to stop new lines being appended in `less`, you can type `ctrl+c`, and to start again, you can type `F`.

# What You Get

* Ubuntu 14.04
* WordPress trunk
* [VIP MU Plugins](https://github.com/Automattic/vip-mu-plugins-public) - including Jetpack, VaultPress and Akismet
* WordPress site
* WP-CLI
* MySQL
* PHP
* Nginx
