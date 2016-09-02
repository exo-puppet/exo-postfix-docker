class postfix_docker (
  $image_version        = '1.0.0',
  $install_dir          = '/opt/postfix',
  $log_dir              = '/var/log/postfix',
  $network              = undef,
  $container_labels     = [],
) {
  file { "${postfix_docker::install_dir}" :
    ensure      => directory,
    owner       => 'root',
    group       => 'root',
    mode        => '755',
  }
  file { "${postfix_docker::log_dir}" :
    ensure      => directory,
    owner       => '1000',
    group       => 'syslog',
    mode        => '750',
  }

  ########################
  ## Docker compose file
  ########################
  file { "${postfix_docker::install_dir}/docker-compose.yml" :
    ensure      => 'present',
    content     => template ('postfix_docker/docker-compose.yml.erb'),
    owner       => 'root',
    group       => 'root',
    mode        => '640',
  } ->

  ###########################
  #  Launch the container
  ###########################
  docker_compose { "${postfix_docker::install_dir}/docker-compose.yml" :
    ensure      => 'present',
    require     => [
      Class['docker::compose'],
      File["${postfix_docker::install_dir}/docker-compose.yml"],
      File["${postfix_docker::log_dir}"],
    ],
  }


}