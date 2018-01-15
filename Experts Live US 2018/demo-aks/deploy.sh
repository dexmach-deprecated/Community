#!/usr/bin/env bash

########################
# include the magic
########################
. ../demo-magic.sh


##
## if this does not work -- use bburns https://github.com/brendandburns/acs-ignite-demos
##

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
# 
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear


rgname="sca-k8sdemo01"
location="eastus"
acrName="scak8sacr"
aksName="scak8s"
email="stijn.callebaut@itnetx.be"

#create resourcegroup
pe "az group create --location $location --name $rgname"

#create registry
pe "az acr create --location $location --name $acrName --resource-group $rgname --sku Basic --admin-enabled"
pe "pass="$(az acr credential show --name $acrName --query "passwords[0].value" -o tsv)""

#create cluster
pe "az aks create --location $location --name $aksName --resource-group $rgname --node-count 4 --generate-ssh-keys"
pe "az aks get-credentials --resource-group $rgname -n $aksName"

#get kubectl and verify
p "az aks install-cli"
pe "kubectl get nodes"
#create secret
pe "kubectl create secret docker-registry acr --docker-server=$acrName.azurecr.io --docker-username=$acrName --docker-password=$pass --docker-email=$email"
pe "kubectl describe secret"

