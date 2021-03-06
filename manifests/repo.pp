# == Class: elasticsearch::repo
#
# This class exists to install and manage yum and apt repositories
# that contain elasticsearch official elasticsearch packages
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'elasticsearch::repo': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Phil Fenstermacher <mailto:phillip.fenstermacher@gmail.com>
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class kibana::repo {

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd       => '/',
  }

  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      apt::source { 'kibana':
        location    => "http://packages.elastic.co/kibana/${kibana::repo_version}/debian",
        release     => 'stable',
        repos       => 'main',
        key         => 'D88E42B4',
        key_source  => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        include_src => false,
      }
    }
    'RedHat', 'Linux': {
      yumrepo { 'kibana':
        descr    => 'kibana repo',
        baseurl  => "http://packages.elastic.co/kibana/${kibana::repo_version}/centos",
        gpgcheck => 1,
        gpgkey   => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        enabled  => 1,
      }
    }
    'Suse': {
      exec { 'kibana_suse_import_gpg':
        command => 'rpmkeys --import http://packages.elastic.co/GPG-KEY-elasticsearch',
        unless  => 'test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
        notify  => [ Zypprepo['kibana'] ],
      }

      zypprepo { 'kibana':
        baseurl     => "http://packages.elastic.co/kibana/${kibana::repo_version}/centos",
        enabled     => 1,
        autorefresh => 1,
        name        => 'kibana',
        gpgcheck    => 1,
        gpgkey      => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        type        => 'yum',
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }

  # Package pinning
  if ($kibana::package_pin == true and $kibana::version != false) {
    case $::osfamily {
      'Debian': {
        if !defined(Class['apt']) {
          class { 'apt': }
        }

        apt::pin { $kibana::package_name:
          ensure   => 'present',
          packages => $kibana::package_name,
          version  => $kibana::real_version,
          priority => 1000,
        }
      }
      'RedHat', 'Linux': {

        yum::versionlock { "0:kibana-${kibana::real_version}.noarch":
          ensure => 'present',
        }
      }
      default: {
        warning("Unable to pin package for OSfamily \"${::osfamily}\".")
      }
    }
  }

}
