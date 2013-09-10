#!/bin/bash

puppet apply --modulepath=./modules --hiera_config=./hiera.yaml $@ ./manifests/site.pp
