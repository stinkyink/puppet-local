#!/bin/bash

puppet apply --modulepath=./modules:./custom-modules --hiera_config=./hiera.yaml $@ ./manifests/site.pp
