#az login

#make sure helm is installed
# download tar.gz, unpack to location c:\<whatever>
# add location c:\<whatever> to the path env var

#install helm and tiller (server side component) 
helm init
# verify
kubectl get pods --selector=name=tiller  --namespace='kube-system'

#add the service catalog repo
c:\helm\helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
#install service catalog via helm
c:\helm\helm install svc-cat/catalog --name catalog --namespace catalog --set rbacEnable=false
#verify
kubectl get apiservice
#add osba repo
c:\helm\helm repo add azure https://kubernetescharts.blob.core.windows.net/azure
#create spn
$spn = $(az ad sp create-for-rbac) | ConvertFrom-Json

$AZURE_SUBSCRIPTION_ID = $(az account show --query id --output tsv)
$AZURE_TENANT_ID = $spn.tenant
$AZURE_CLIENT_ID = $spn.appId
$AZURE_CLIENT_SECRET = $spn.password

c:\helm\helm install azure/open-service-broker-azure --name osba --namespace osba --set azure.subscriptionId=$AZURE_SUBSCRIPTION_ID --set azure.tenantId=$AZURE_TENANT_ID --set azure.clientId=$AZURE_CLIENT_ID --set azure.clientSecret=$AZURE_CLIENT_SECRET



