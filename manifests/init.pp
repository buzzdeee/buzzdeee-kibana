# == Class: kibana
#
# Full description of class kibana here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'kibana':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class kibana (
  $inst_dir                     = $::kibana::params::inst_dir,
  $configfile                   = $::kibana::params::configfile,
  $init_script                  = $::kibana::params::init_script,
  $install_type                 = $::kibana::params::install_type,
  $git_url                      = $::kibana::params::git_url,
  $git_ref                      = $::kibana::params::git_ref,
  $package_ensure               = $::kibana::params::package_ensure,
  $service_ensure               = $::kibana::params::service_ensure,
  $service_enable               = $::kibana::params::service_enable,
  $service_name                 = $::kibana::params::service_name,
  $service_flags		= undef,
  $sysuser                      = $::kibana::params::sysuser,
  $sysgroup                     = $::kibana::params::sysgroup,
  $sysuid                       = $::kibana::params::sysuid,
  $sysgid                       = $::kibana::params::sysgid,
  $required_npms                = $::kibana::params::required_npms,
  $local_npms                   = $::kibana::params::local_npms,

  # parameters below steer the configuration file
  $server_port                  = undef,
  $server_host                  = undef,
  $server_basepath              = undef,
  $elasticsearch_url            = undef,
  $elasticsearch_preservehost   = undef,
  $kibana_index                 = '.kibana',
  $kibana_defaultappid          = undef,
  $elasticsearch_username       = undef,
  $elasticsearch_password       = undef,
  $server_ssl_cert              = undef,
  $server_ssl_key               = undef,
  $elasticsearch_ssl_cert       = undef,
  $elasticsearch_ssl_key        = undef,
  $elasticsearch_ssl_ca         = undef,
  $elasticsearch_ssl_verify     = undef,
  $elasticsearch_pingtimeout    = undef,
  $elasticsearch_requesttimeout = undef,
  $elasticsearch_shardtimeout   = undef,
  $elasticsearch_startuptimeout = undef,
  $pid_file                     = $::kibana::params::pid_file,
  $logging_dest                 = $::kibana::params::logging_dest,
  $logging_silent               = undef,
  $logging_quiet                = undef,
  $logging_verbose              = undef,
  $bundled_plugin_ids           = $::kibana::params::bundled_plugin_ids,
) inherits kibana::params {

  class { 'kibana::install':
    required_npms => $required_npms,
    local_npms    => $local_npms,
    inst_dir      => $inst_dir,
    configfile    => $configfile,
    install_type  => $install_type,
    git_url       => $git_url,
    git_ref       => $git_ref,
    ensure        => $package_ensure,
    sysuser       => $sysuser,
    sysgroup      => $sysgroup,
    sysuid        => $sysuid,
    sysgid        => $sysgid,
    pid_file      => $pid_file,
    logging_dest  => $logging_dest,
  }

  class { 'kibana::config':
    configfile                   => $configfile,
    sysuser                      => $sysuser,
    sysgroup                     => $sysgroup,
    server_port                  => $server_port,
    server_host                  => $server_host,
    server_basepath              => $server_basepath,
    elasticsearch_url            => $elasticsearch_url,
    elasticsearch_preservehost   => $elasticsearch_preservehost,
    kibana_index                 => $kibana_index,
    kibana_defaultappid          => $kibana_defaultappid,
    elasticsearch_username       => $elasticsearch_username,
    elasticsearch_password       => $elasticsearch_password,
    server_ssl_cert              => $server_ssl_cert,
    server_ssl_key               => $server_ssl_key,
    elasticsearch_ssl_cert       => $elasticsearch_ssl_cert,
    elasticsearch_ssl_key        => $elasticsearch_ssl_key,    
    elasticsearch_ssl_ca         => $elasticsearch_ssl_ca,
    elasticsearch_ssl_verify     => $elasticsearch_ssl_verify,
    elasticsearch_pingtimeout    => $elasticsearch_pingtimeout,
    elasticsearch_requesttimeout => $elasticsearch_requesttimeout,
    elasticsearch_shardtimeout   => $elasticsearch_shardtimeout,
    elasticsearch_startuptimeout => $elasticsearch_startuptimeout,
    pid_file                     => $pid_file,
    logging_dest                 => $logging_dest,
    logging_silent               => $logging_silent,
    logging_quiet                => $logging_quiet,
    logging_verbose              => $logging_verbose,
    bundled_plugin_ids           => $bundled_plugin_ids,
  }

  class { 'kibana::service':
    ensure        => $service_ensure,
    enable        => $service_enable,
    service_name  => $service_name,
    service_flags => $service_flags,
    inst_dir      => $inst_dir,
    init_script   => $init_script,
    configfile    => $configfile,
    sysuser       => $sysuser,
    install_type  => $install_type
  }

  Class['kibana::install'] ->
  Class['kibana::config']  ~>
  Class['kibana::service']

}
