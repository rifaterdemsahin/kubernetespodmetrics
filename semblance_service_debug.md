@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $   kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apiregistration.k8s.io/v1","kind":"APIService","metadata":{"annotations":{},"labels":{"k8s-app":"metrics-server"},"name":"v1beta1.metrics.k8s.io"},"spec":{"group":"metrics.k8s.io","groupPriorityMinimum":100,"insecureSkipTLSVerify":true,"service":{"name":"metrics-server","namespace":"kube-system"},"version":"v1beta1","versionPriority":100}}
  creationTimestamp: "2024-10-23T15:10:15Z"
  labels:
    k8s-app: metrics-server
  name: v1beta1.metrics.k8s.io
  resourceVersion: "583"
  uid: b2bfd11a-11e4-4dc8-9e23-575857601135
spec:
  group: metrics.k8s.io
  groupPriorityMinimum: 100
  insecureSkipTLSVerify: true
  service:
    name: metrics-server
    namespace: kube-system
    port: 443
  version: v1beta1
  versionPriority: 100
status:
  conditions:
  - lastTransitionTime: "2024-10-23T15:10:15Z"
    message: endpoints for service/metrics-server in "kube-system" have no addresses
      with port name "https"
    reason: MissingEndpoints
    status: "False"
    type: Available
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 