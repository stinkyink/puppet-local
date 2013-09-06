class role {
  include stdlib

  $roles = hiera_array('roles')

  if member($roles, 'role::base') {
    require role::base
  }

  include $roles
}
