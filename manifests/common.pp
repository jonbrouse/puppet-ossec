
#
#
class ossec::common {
  if (!defined(File['/opt'])) {
    file { "/opt":
      ensure => directory
    }
  }
  case $lsbdistid {
    /(Ubuntu|ubuntu|Debian|debian)/ : {
      $hidsagentservice='ossec-hids-agent'
      $hidsagentpackage='ossec-hids-agent'
      $hidsserverservice='ossec-hids-server'
      $hidsserverpackage='ossec-hids-server'
      if (!defined(File['/opt/debs'])) {
        file { "/opt/debs":
          ensure => directory
        }
      }
      case "${lsbdistcodename}" {
        /(lucid|precise|trusty)/: { 
          apt::ppa { 'ppa:nicolas-zin/ossec-ubuntu': }
        }
        default : { fail("This ossec module has not been tested on your distribution (or 'redhat-lsb' package not installed)") }
      }
    }
    /(CentOS|Redhat|RedHatEnterpriseServer)/ : {
      # Set up Atomic rpm repo
      class { '::atomic':
        includepkgs => 'ossec-hids*',
      }
      $hidsagentservice='ossec-hids'
      $hidsagentpackage='ossec-hids-client'
      $hidsserverservice='ossec-hids'
      $hidsserverpackage='ossec-hids-server'
      case $operatingsystemrelease {
        /^5/: {$redhatversion='el5'}
        /^6/: {$redhatversion='el6'}
      }
      package { 'inotify-tools': ensure=>present}
      if (!defined(File['/opt/rpm'])) {
        file { "/opt/rpm":
          ensure => directory
        }
      }
    }
    default : { fail("This ossec module has not been tested on your distribution") }
  }
}

