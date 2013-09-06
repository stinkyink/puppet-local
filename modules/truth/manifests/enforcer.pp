class truth::enforcer {
  if has_role("rails_app") {
    notice("Rails App role enabled.")
  } else {
    notice("Rails App role disabled.")
  }
}
