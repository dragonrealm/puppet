# Module to let puppet manage itself
class puppet {
  case $::osfamily {
    'Debian': {
      $package = [ 'puppet-common', 'puppet' ]
      $config  = '/etc/puppet/puppet.conf'
      $service = 'puppet'
    }
    'FreeBSD': {
      $package = 'puppet'
      $config  = '/usr/local/etc/puppet/puppet.conf'
      $service = 'puppet'
    }
    default: {
      fail("Module ${module_name} not configured for ${::osfamily}")
    }
  }

  package { $package:
    ensure => latest,
  }
  
  if ($::osfamily == 'Debian') {
    augeas { '/etc/default/puppet':
      changes => 'set /files/etc/default/puppet/START yes',
    }
      
    augeas { $config:
      changes => "rm /files/${config}/main/templatedir",
    }
  }

  service { $service:
    ensure => running,
    enable => true,
  }
}
