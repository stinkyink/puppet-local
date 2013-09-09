class role::base {
  class { "apt": }
  class { "ntp": }
  class { 'ssh': }
  class { "timezone":
    timezone => "Etc/UTC"
  }

  # Some core packages that we just love to have on all boxes.
  package { ["zsh", "curl", "vim", "git"]:
    ensure => present
  }
}
