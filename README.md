![VIP Quickstart](http://vip.wordpress.com/wp-content/themes/a8c/wpcomvip3/img/illustrations/developmenttools-03.svg)

# Overview

VIP Quickstart is a local development environment for WordPress.com VIP developers. The goal is to provide developers with an environment that closely mirrors production environment along with all the tools we recommend developers use.

# How to use VIP Quickstart

## Installation

1. Clone this repository to your local machine

2. Move to vip-quickstart directory

3. Start the Vagrant

```
cd ~
git clone https://github.com/david-binda/qsv2.git vip-quickstart
cd vip-quickstart
vagrant up
``` 

You'll be promted for your local machine password during the booting process of Vagrant as a NFS filesystem is being set up. NFS filesystem is used for sharing files in `wp-content/themes` and `wp-content/plugins` to `~/vip-quickstart/themes` and `~/vip-quickstart/plugins` respectively. That will allow you to easily develop from your host machine using your favorite tools.

## Viewing your WordPress site

Before you'll be able to view your WordPress site, a configuration line has to be added to hosts file:

```
10.86.73.80 vip.local
```

Now you can navigate to [vip.local](http://vip.local) in your browser and you should land on a fresh WordPress site.

## Entering WordPress administration

Once you are able to view the site via browser, you can also visit [vip.local/wp-admin](http://vip.local/wp-admin) and log in using following credentials:

user: `wordpress`

password: `wordpress`

## Developing themes and plugins

There are two shared folders: `~/vip-quickstart/themes` and `~/vip-quickstart/plugins` which can be accessible from both, the host and guest machine. All changes are automaticaly mirrored on both systems which means that you can edit files using your favorite tools and see the changes live on vip.local site.

Those folders are mounted to `/var/www/wp-content/themes` and `/var/www/wp-content/plugins` on the guest machine.

The root directory for WordPress instalation on the guest machine is in `/var/www` and that can be accessed, if necessary, via `vagrant ssh` command:

```
vagrant up
vagrant ssh
cd /var/www
```

## Viewing logs

Logs are being written to guest machine only to `/var/log/nginx/vip.local.error.log` file. You can view them from vagrant machine:

```
vagrant up
vagrant ssh
less +F /var/log/nginx/vip.local.error.log
```

# What You Get

* Ubuntu 14.04
* WordPress trunk
* [VIP MU Plugins](https://github.com/Automattic/vip-mu-plugins-public) - including Jetpack, VaultPress and Akismet
* WordPress site
* WP-CLI
* MySQL
* PHP
* Nginx
