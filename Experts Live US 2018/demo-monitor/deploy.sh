#!/usr/bin/env bash

########################
# include the magic
########################
. ../demo-magic.sh

pe "cat oms_daemonset.yaml"

pe "kubectl apply -f oms_daemonset.yaml"