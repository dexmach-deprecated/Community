kubectl create namespace oms
kubectl create -f .\oms_secret.yml --namespace oms

#oms is deployed as a deamonset.
#deamonset = ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.
#for log collection -- you typically want a pod on every node to collect logs
notepad .\oms_daemonset.yml

#apply using a file
kubectl apply -f oms_daemonset.yml --namespace oms

#let's have a look in OMS
https://portal.azure.com