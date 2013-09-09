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

  class { "ruby::ng::experimental": }
  class { "ruby::ruby2":
    system_default => true,
    require        => Class["ruby::ng::experimental"]
  }
}
