Stinkyink Internal Puppet
=========================

This contains all the puppet modules and manifests used for internal servers at
[http://www.stinkyink.com](stinkyink.com). For our internal VMs we operate a nodeless/masterless
setup, using hiera config files to setup the different roles that a given node
might need.


Setup
-----

### Puppet

We use Ubuntu on all our boxes, the easiest way to get Puppet setup is to use
the puppetlabs repository. Visit http://apt.puppetlabs.com and find the right
puppetlabs-release-\* deb for your version of Ubuntu and install it with dpkg.

    $ wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb && dpkg -i puppetlabs-release-precise.deb

Then update apt and install puppet (we don't need to install puppetmaster).

    $ sudo apt-get update
    $ sudo apt-get install puppet


### Clone / Sync this repository

_NOTE: You do not need to do this if you're developing changes, please see
Vagrant section of this README_

We need to get the contents of our configuration files onto the server. The
easiest method is to clone the repository into /etc/puppet, or a location of
your choice (being masterless we can run it from anywhere).

You will probably need to install git first:

    $ sudo apt-get install git

Then clone the repository, for example into /etc/puppet:

    $ sudo git clone https://github.com/stinkyink/puppet-local.git /etc/puppet

### Puppet Librarian

We use [Puppet Librarian](https://github.com/rodjek/librarian-puppet) to manage
our external modules; this is similar to Bundler.

Run the following commands to install the gem and then bundle the modules. If
you need more help please refer to the Librarian documentation.

    $ gem install librarian-puppet
    $ librarian-puppet install


Roles/Configuration
-------------------

We have a base role that is used on every box, it will do:

* Install ruby 2.0 as default
* Install vim
* Install zsh shell
* Install git (if not already installed)
* Install ntpd for time management
* Install curl
* Configure UTC as timezone
* Configure ssh to disable root login

To install other packages you must configure the node to take on more roles,
this is done via [Hiera configuration files](http://docs.puppetlabs.com/hiera/1/index.html).

The base node is defined in the file *hiera/common/roles.yaml* to define roles
for a node you should create *hiera/node/roles.yaml*, example content:

```yaml
---
roles:
  - role::worker
  - role::cacheserver
```

For a list of roles please see the [role module](https://github.com/stinkyink/puppet-local/tree/master/custom-modules/role/manifests)


### Configure users

You can configure users to create on the node in the following files:

* hiera/common/_users.yaml
* hiera/node/_users.yaml

These files are not part of this repository due to them containing sensitive
data ( _stinkyink employees see setup.sh / private repo for this_ ).

An example of such a configuration:


```yaml
---
ssh_users:
  johndoe:
   comment: "John Doe"
   groups: ["sudo"]
   shell: "/bin/bash"
   pwhash: '$6$wVWsmNcN$t4G3kuGyWvdtQ.X51jZGPdSZaB.5wA/6F7qzyJ4CaUmasZZA94v2qw9vZueyXRSeRBWmHxCKBdiLIK35lyK3y0'
   uid: 1002
   gid: 1002
   ssh_key:
    type: "ssh-rsa"
    comment: "john@pc"
    key: "AAAAB3NzaC1yc2EAAAADAQABAAABAQDIRsDur48bb8kTvrtg9uSzu722964xQ+4Pnu...
```


Running Puppet
--------------

When you have configured everything you can run Puppet from the root of this
project with the following command:

    $ sudo puppet apply --modulepath=./modules:./custom-modules --hiera_config=./hiera.yaml ./manifests/site.pp

For convinence we provide a shorthand script to run this for you, command line
arguments are proxied to puppet apply.

    $ sudo ./run-puppet.sh --debug


Contributing / Vagrant
----------------------

To make changes, or to test new Puppet modules, we make use of ()[Vagrant],
 please see their documentation for more information on how to install Vagrant.

Our Vagrant configuration will automatically mount this repository to
/etc/puppet, there is no need to do the *git clone* step.

You will need to configure the roles for your VM node, see setup above.

Example commands for use with Vagrant:

    $ # Do steps in Setup stage of README
    $ vagrant up
    $ vagrant ssh
    $ cd /etc/puppet
    $ sudo ./run-puppet.sh

To make changes do them on your local machine and rerun  *puppet-run.sh* on
the VM.

_NOTE: If you run across problems with roles running when they shouldn't then
make sure you don't already have an existing node/roles.yaml file._
