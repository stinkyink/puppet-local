# Add a puppet parser function called 'has_role'
#   * Takes 1 argument, the role name.
#   * Expects a fact 'server_tags' to be a comma-delimited string containing roles
#
# We use rightscale, which supports "tagging" a server with any number of tags
# The tags are of the format: namespace:predicate=value
# http://support.rightscale.com/12-Guides/RightScale_Methodologies/Tagging
#
# This function expects the fact 'server_tags' to be comma-delimited
#   Each value in server_tags must be of the format described above.
#   Roles are expected to be of format: "role:<role>=true"
#   For example, the role 'loadbalancer' is "role:loadbalancer=true"
#

module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
    args = [*args] # Ensure it's an array.

    server_tags = lookupvar("server_tags")
    return false unless server_tags

    role = args[0]
    roles = server_tags.split(",").grep(/^role:/)
    roletag_re = /^role:#{role}(?:=.+)?$/
    return (roles.grep(roletag_re).length > 0)
  end # puppet function has_role
end # module Puppet::Parser::Functions
