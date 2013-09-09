class role::worker {
  class { "redis":
    require => Class["ruby::ruby2"]
  }

  class { "ruby::rails": }
}
