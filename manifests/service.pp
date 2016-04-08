# class takes care to manage the kibana service
# 

class kibana::service (
  $ensure,
  $enable,
  $service_name,
  $service_flags,
  $inst_dir,
  $init_script,
  $configfile,
  $sysuser,
  $install_type,
) {

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
    flags   => $service_flags,
  } 

  if $install_type == 'git' {
    file { $init_script:
      owner   => 'root',
      group   => '0',
      mode    => '0555',
      content => template('kibana/kibana.erb'),
      before  => Service[$service_name],
    }
  }
}
