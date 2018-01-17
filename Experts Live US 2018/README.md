# ExpertsLive US 2018 - Containers for IT Pro's

Containers are the new kid on the block for application management. Do you want to better understand the impact of containers on IT Operations? We will take a hands-on by deploying a containerized application, including demonstrating orchestration and deployment with Docker and Kubernetes...with a strong IT operations focus. If learning Docker is on your 2018 to-do list, then this session is for you!

## slides
see the link [pdf slides](\slidedeck\containers-for-it-operations.pdf)

## Demo's

### pre-requisites

install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) or make use of [cloudshell](https://shell.azure.com)
### create k8s cluster
``` bash
pushd
cd demo-cluster
./demo.sh
popd
```

### deploy application
``` bash
pushd
cd demo-app
./demo.sh
popd
```
### monitor (using oms)
``` bash
pushd
cd demo-app
./demo.sh
popd
```