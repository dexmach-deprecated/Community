#Add-AzureRmAccount

$rgname="elusk8sdemo-rg"
$location="eastus"
$acrName="elusk8sdemoacr"
$aksName="elusk8s"
$email="stijn.callebaut@itnetx.be"

#create resourcegroup
az group create --location $location --name $rgname

#create registry
az acr create --location $location --name $acrName --resource-group $rgname --sku Basic --admin-enabled
$pass=$(az acr credential show --name $acrName --query "passwords[0].value" -o tsv)

#create cluster
az aks create --location $location --name $aksName --resource-group $rgname --node-count 4 --generate-ssh-keys
az aks get-credentials --resource-group $rgname -n $aksName

#get kubectl and verify
#az aks install-cli
kubectl config get-contexts
kubectl cluster-info

kubectl get nodes
#see also vscode kubernetes extension
az aks browse --resource-group $rgname --name $aksName
#create secret
kubectl create secret docker-registry acr --docker-server=$acrName.azurecr.io --docker-username=$acrName --docker-password=$pass --docker-email=$email
kubectl describe secret

#upgrade to latest - kubectl dashboard issue
az aks get-versions -g $rgname -n $aksName -o table
az aks upgrade --name $aksName --resource-group $rgname --kubernetes-version 1.8.7

#create namespace and temp password
kubectl create namespace demo02
kubectl create secret generic mysql-pass --from-literal=password=<PASSWORD> --namespace=demo02