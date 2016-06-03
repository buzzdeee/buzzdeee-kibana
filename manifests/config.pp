# class that takes care to configure kibana
class kibana::config (
  $configfile,
  $sysuser,
  $sysgroup,
  $server_port,
  $server_host,
  $server_basepath,
  $elasticsearch_url,
  $elasticsearch_preservehost,
  $kibana_index,
  $kibana_defaultappid,
  $elasticsearch_username,
  $elasticsearch_password,
  $server_ssl_cert,
  $server_ssl_key,
  $elasticsearch_ssl_cert,
  $elasticsearch_ssl_key,
  $elasticsearch_ssl_ca,
  $elasticsearch_ssl_verify,
  $elasticsearch_pingtimeout,
  $elasticsearch_requesttimeout,
  $elasticsearch_shardtimeout,
  $elasticsearch_startuptimeout,
  $pid_file,
  $logging_dest,
  $logging_silent,
  $logging_quiet,
  $logging_verbose,
  $bundled_plugin_ids,
) {

  file { $configfile:
    owner   => 'root',
    group   => $sysgroup,
    mode    => '0440',
    content => template('kibana/kibana.yml.erb')
  }

  if $logging_dest {
    if $logging_dest != 'stdout' and $logging_dest != 'stderr' {
      validate_absolute_path($logging_dest)
      $logdir = dirname($logging_dest)
      file { $logdir:
        ensure => 'directory',
        owner  => $sysuser,
        group  => $sysgroup,
        mode   => '0750',
      }
    }
  }

}
