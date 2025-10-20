helm install kong --namespace kong --create-namespace --repo https://charts.konghq.com ingress -f k8s/values.override.yml

kubectl create configmap kong-plugin-myheader --from-file=myheader -n kong

kubectl create configmap kong-plugin-xml2lua --from-file=xml2lua -n kong


kubectl create configmap kong-plugin-myjwt --from-file=myjwt -n kong


helm upgrade --install kong kong/ingress -n kong --create-namespace --values k8s/values.override.yml 