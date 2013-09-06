class role::base {
  class { "apt": }
  class { "ntp": }
  class { 'ssh': }
  class { "timezone":
    timezone => "Etc/UTC"
  }
}
