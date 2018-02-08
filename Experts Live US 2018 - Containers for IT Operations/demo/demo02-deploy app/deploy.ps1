kubectl config set-context elusk8s

kubectl get namespace demo02

#MySQL
kubectl create -f '.\01 mysql\mysql_service.yml' --namespace demo02
kubectl get services --namespace demo02

kubectl create -f '.\01 mysql\mysql_persistentvolume.yml' --namespace demo02
kubectl get persistentvolumeclaims --namespace demo02 --watch

kubectl create -f '.\01 mysql\mysql_deployment.yml' --namespace demo02
kubectl get pods --selector=app=wordpress,tier=mysql --namespace demo02 --watch

#Wordpress
kubectl create -f '.\02 wordpress\wp_service.yml' --namespace demo02
kubectl get services --namespace demo02

kubectl create -f '.\02 wordpress\wp_persistentvolume.yml' --namespace demo02
kubectl get persistentvolumeclaims --namespace demo02 --watch

kubectl create -f '.\02 wordpress\wp_deployment.yml' --namespace demo02
kubectl get pods --selector=app=wordpress,tier=frontend --namespace demo02 --watch

kubectl get services wordpress --namespace demo02