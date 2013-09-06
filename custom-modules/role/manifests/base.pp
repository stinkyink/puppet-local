class role::base {
  class { "apt": }
  class { "ntp": }
  class { "openssh":
    template => "openssh/sshd_config-wheezy.erb",
    options  => { "PermitRootLogin" => "no" }
  }
  class { "timezone":
    timezone => "Etc/UTC"
  }
}
