# the parameters that drive this class
class kibana::params {
  case $::osfamily {
    'OpenBSD': {
      $inst_dir        = '/usr/local/kibana'
      $configfile      = '/etc/kibana.yml'
      $init_script     = '/etc/rc.d/kibana'
      $git_url         = 'https://github.com/elastic/kibana.git'
      $git_ref         = 'HEAD'
      $package_ensure  = 'present'
      $service_ensure  = 'running'
      $service_enabled = true
      $service_name    = 'kibana'
      $sysuser         = '_kibana'
      $sysgroup        = '_kibana'
      $sysuid          = '40000'
      $sysgid          = '40000'
      $logging_dest    = '/var/log/kibana/kibana.log'
      $pid_file        = '/var/run/kibana/kibana.pid'
      $required_npms   = [ 'bower', 'grunt-cli', ]
      $local_npms      = [ 'angular-mocks', 'glob', ]
      $install_type    = 'package'	# or may be 'git'
    }
    default: {
      fail("${::module_name} doesn't support osfamily: ${::osfamily}")
    }
  }
  
}
