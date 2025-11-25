chmod +x helm.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack -n task --create-namespace

kubectl edit svc monitoring-grafana -n task
sleep 30

kubectl patch svc monitoring-grafana -n task -p '{"spec": {"type": "LoadBalancer"}}'A
sleep 30

kubectl get svc -n task monitoring-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

kubectl get secret --namespace task monitoring-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode; echo
