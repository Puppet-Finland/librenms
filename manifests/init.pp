#
# == Class: librenms
#
# A Puppet module for managing librenms:
#
# <http://www.librenms.org>
#
class librenms
(
    $admin_pass,
    $db_pass,
    $user = 'librenms',
    $server_name = $::fqdn,
    $clone_source = $::librenms::params::clone_source,
    $clone_target = '/opt/librenms',
    $admin_user = 'admin',
    $admin_email = $::serveradmin,
    $db_user = 'librenms',
    $db_host = 'localhost',

) inherits librenms::params
{

    class { '::apache2':
        purge_default_sites => true,
        modules             => {
            'rewrite' => {}
        },
    }

    include ::apache2::config::php

    class { '::librenms::install':
        user         => $user,
        clone_source => $clone_source,
        basedir      => $clone_target,
    }

    class { '::librenms::config':
        system_user => $user,
        basedir     => $clone_target,
        server_name => $server_name,
        admin_user  => $admin_user,
        admin_pass  => $admin_pass,
        admin_email => $admin_email,
        db_user     => $db_user,
        db_host     => $db_host,
        db_pass     => $db_pass
    }

    include ::librenms::devices
}
