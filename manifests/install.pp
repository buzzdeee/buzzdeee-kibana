# class that takes care to install kibana
class kibana::install (
  $inst_dir,
  $configfile,
  $required_npms,
  $local_npms,
  $ensure,
  $git_url,
  $git_ref,
  $sysuser,
  $sysgroup,
  $sysuid,
  $sysgid,
  $pid_file,
  $logging_dest,
) {

  require nodejs

  group { $sysgroup:
    gid => $sysgid,
  }

  user { $sysuser:
    uid        => $sysuid,
    gid        => $sysgid,
    loginclass => 'staff',
    shell      => '/sbin/nologin',
    home       => $inst_dir,
  }

  package { $required_npms:
    ensure   => $package_ensure,
    provider => 'npm',
  }

  file { $inst_dir:
    ensure => 'directory',
    owner  => $sysuser,
  }

  vcsrepo { $inst_dir:
    provider => 'git',
    source   => $git_url,
    revision => $git_ref,
    user     => $sysuser,
    require  => File[$inst_dir],
    notify   => Exec['install_kibana'],
  }

  exec { 'install_kibana':
    cwd         => $inst_dir,
    command     => '/usr/local/bin/npm install --production',
    environment => 'NODE_ENV=production',
    user        => $sysuser,
    timeout     => '900',
    refreshonly => true,
  }

  nodejs::npm { $local_npms:
    target => $inst_dir,
    require => Exec['install_kibana'],
  }

  

  #nodejs::npm { 'kibana':
  #  target          => $inst_dir,
  #  source          => 'elastic/kibana',
  #  require         => File[$inst_dir],
  #  timeout         => '900',
  #  user            => $sysuser,
  #  home_dir        => $inst_dir,
  #  install_options => [ '--production', ],
  #}

}
