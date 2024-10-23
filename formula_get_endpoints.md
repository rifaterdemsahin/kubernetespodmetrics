@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get endpoints metrics-server -n kube-system -o yaml
apiVersion: v1
kind: Endpoints
metadata:
  creationTimestamp: "2024-10-23T15:10:15Z"
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
  resourceVersion: "1207"
  uid: cc809d25-01d1-491f-ace6-430dbf01c6fe
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 
