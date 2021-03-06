# Class: example::profile
#
# This is an example of how your profile could look when using the cloudstack module
# Choose between 3-in-1 or separate parts. Don't copy this example blindly.
#
# (*) It is highly recommended to put secret keys in Hiera-eyaml
#
class example::profile {
  # Dependencies
    # if mysql_server = true
    include 'mysql::server'

    # if nfs_server = true
    include 'nfs::server'


  # Cloudstack 3-in-1
  class { 'cloudstack':
    hostname_cloudstack          => '192.168.1.1',

    database_server_key           => 'notsecretnow', # (*)
    database_database_key         => 'notsecretnow', # (*)
    database_password             => 'notsecretnow', # (*)

    hypervisor_support            => ['xenserver', 'kvm', 'lxc'],
    cloudstack_server_count       => 1,
  }


  # Cloudstack - MySQL only
  class { 'cloudstack':
    cloudstack_server             => false,
    nfs_server                    => false,

    cloudstack_server_count       => 2,
  }

  # Cloudstack - NFS only
  class { 'cloudstack':
    cloudstack_server   => false,
    mysql_server        => false,
  }

  # Cloudstack - Cloudstack Server only
  class { 'cloudstack':
    nfs_server                    => false,
    mysql_server                  => false,

    hostname_cloudstack           => '192.168.1.1',
    hostname_database             => '192.168.1.2',
    hostname_nfs                  => '192.168.1.3',

    database_server_key           => 'notsecretnow', # (*)
    database_database_key         => 'notsecretnow', # (*)
    database_password             => 'notsecretnow', # (*)

    hypervisor_support            => ['xenserver', 'kvm', 'lxc'],
  }

  # Cloudstack - Second Cloudstack Server
  class { 'cloudstack':
    nfs_server                    => false,
    mysql_server                  => false,

    hostname_cloudstack           => '192.168.1.4',
    hostname_database             => '192.168.1.2',
    hostname_nfs                  => '192.168.1.3',

    database_server_key           => 'notsecretnow', # (*)
    database_database_key         => 'notsecretnow', # (*)
    database_password             => 'notsecretnow', # (*)

    cloudstack_master             => false,
  }


  # Class Dependencies/Sequence
  Class['nfs::server'] -> Class['cloudstack']


  # Integrate REST API - Allow Custom Types
  class { 'cloudstack::api':
    api_key    => 'TODO',# get from webinterface
    api_secret => 'TODO',# get from webinterface
  }


  # CloudMonkey
  contain ::cloudstack::cloudmonkey
}
