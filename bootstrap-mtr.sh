#!/usr/bin/env bash
echo "Starting Master Node Configuration"
echo "$@" > /tmp/mn_passed_args
/vagrant/bootstrap-nix.sh "$1" "$2" "$3"

## Copy over our Master App
cp -r /vagrant/configs/master/APL-masternode /opt/splunk/etc/apps

## Final Configuration Tasks
/vagrant/bootstrap-final.sh
