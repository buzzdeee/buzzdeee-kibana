# class takes care to manage the kibana service
# 

class kibana::service (
  $ensure,
  $enable,
  $service_name,
  $inst_dir,
  $init_script,
  $configfile,
  $sysuser,
) {

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
    require => File[$init_script],
  } 

  file { $init_script:
    owner   => 'root',
    group   => '0',
    mode    => '0555',
    content => template('kibana/kibana.erb')
  }
}
