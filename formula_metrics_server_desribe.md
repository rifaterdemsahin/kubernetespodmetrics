@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get deployment metrics-server -n kube-system -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"metrics-server","namespace":"kube-system"},"spec":{"selector":{"matchLabels":{"k8s-app":"metrics-server"}},"template":{"metadata":{"labels":{"k8s-app":"metrics-server"}},"spec":{"containers":[{"args":["--kubelet-insecure-tls"],"image":"k8s.gcr.io/metrics-server/metrics-server:v0.6.2","name":"metrics-server","ports":[{"containerPort":443,"protocol":"TCP"}],"securityContext":{"runAsGroup":3000,"runAsUser":1000},"volumeMounts":[{"mountPath":"/apiserver.local.config","name":"tmp-cert-storage"}]}],"securityContext":{"fsGroup":2000},"volumes":[{"emptyDir":{},"name":"tmp-cert-storage"}]}}}}
  creationTimestamp: "2024-10-23T15:10:15Z"
  generation: 3
  name: metrics-server
  namespace: kube-system
  resourceVersion: "1482"
  uid: 19e72e56-69fb-4554-ae78-0e43b61416e5
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: metrics-server
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2024-10-23T15:23:39Z"
      creationTimestamp: null
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --kubelet-insecure-tls
        image: k8s.gcr.io/metrics-server/metrics-server:v0.6.2
        imagePullPolicy: IfNotPresent
        name: metrics-server
        ports:
        - containerPort: 443
          protocol: TCP
        resources: {}
        securityContext:
          runAsGroup: 3000
          runAsUser: 1000
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /apiserver.local.config
          name: tmp-cert-storage
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 2000
      serviceAccount: metrics-server
      serviceAccountName: metrics-server
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: tmp-cert-storage
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2024-10-23T15:18:48Z"
    lastUpdateTime: "2024-10-23T15:18:48Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2024-10-23T15:10:15Z"
    lastUpdateTime: "2024-10-23T15:23:41Z"
    message: ReplicaSet "metrics-server-6bb8bdd84c" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 1
  replicas: 1
  updatedReplicas: 1
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 



rifaterdemsahin: how and why to solve it > ```sh
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
error: Metrics API not available
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $
```

GitHub Copilot: The error `Metrics API not available` indicates that the Kubernetes Metrics Server is not installed or not running in your cluster. The Metrics Server is responsible for collecting resource metrics from the kubelet and exposing them through the Kubernetes API.

### Steps to solve the issue:

1. **Install the Metrics Server:**
   - You can install the Metrics Server using the following command:
     ```sh
     kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
     ```

2. **Verify the Metrics Server is running:**
   - Check the status of the Metrics Server pods:
     ```sh
     kubectl get pods -n kube-system | grep metrics-server
     ```
   - Ensure that the Metrics Server pods are in the `Running` state.

3. **Check Metrics API availability:**
   - After installing the Metrics Server, you can verify if the Metrics API is available by running:
     ```sh
     kubectl top nodes
     ```
   - If the command returns node metrics, the Metrics Server is working correctly.

### Why this solves the issue:
- The Metrics Server collects and provides resource usage metrics for nodes and pods. Without it, the `kubectl top` commands cannot retrieve the necessary data, resulting in the `Metrics API not available` error. Installing and running the Metrics Server ensures that these metrics are available for monitoring and scaling purposes.

rifaterdemsahin: if metric server are running do i get > @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods error: Metrics API not available @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $

GitHub Copilot: If the Metrics Server is running, you should not get the `Metrics API not available` error when running `kubectl top pods`. Instead, you should see the resource usage metrics for the pods.

Given the excerpt from your active file, it shows that the Metrics Server pod is running:
```
kube-system   metrics-server-6f855c96bf-8h9ss    1/1     Running   0               110s
```

### Steps to troubleshoot:

1. **Check Metrics Server logs:**
   ```sh
   kubectl logs -n kube-system metrics-server-6f855c96bf-8h9ss
   ```
   Look for any errors or warnings in the logs.

2. **Ensure Metrics Server has the necessary permissions:**
   Verify that the Metrics Server has the correct ClusterRole and ClusterRoleBinding:
   ```sh
   kubectl get clusterrole system:metrics-server
   kubectl get clusterrolebinding system:metrics-server
   ```

3. **Check APIService status:**
   Ensure that the `v1beta1.metrics.k8s.io` APIService is available:
   ```sh
   kubectl get apiservice v1beta1.metrics.k8s.io
   ```
   The status should show `Available`.

4. **Verify network policies:**
   Ensure there are no network policies blocking the Metrics Server from communicating with the kubelets.

### Example of successful `kubectl top pods` output:
```sh
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
NAME                               CPU(cores)   MEMORY(bytes)
coredns-6f6b679f8f-slm7x           2m           12Mi
etcd-minikube                      10m          50Mi
kube-apiserver-minikube            20m          100Mi
kube-controller-manager-minikube   5m           30Mi
kube-proxy-7lpg8                   1m           10Mi
kube-scheduler-minikube            3m           20Mi
metrics-server-6f855c96bf-8h9ss    1m           15Mi
storage-provisioner                2m           25Mi
```

If you still encounter issues, the logs and status checks should provide more insight into what might be going wrong.

rifaterdemsahin: @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl logs -n kube-system metrics-server-6f855c96bf-8h9ss
I1023 15:18:47.996395       1 serving.go:342] Generated self-signed cert (apiserver.local.config/certificates/apiserver.crt, apiserver.local.config/certificates/apiserver.key)
I1023 15:18:48.873333       1 secure_serving.go:266] Serving securely on [::]:443
I1023 15:18:48.873383       1 requestheader_controller.go:169] Starting RequestHeaderAuthRequestController
I1023 15:18:48.873391       1 shared_informer.go:240] Waiting for caches to sync for RequestHeaderAuthRequestController
I1023 15:18:48.873430       1 dynamic_serving_content.go:131] "Starting controller" name="serving-cert::apiserver.local.config/certificates/apiserver.crt::apiserver.local.config/certificates/apiserver.key"
W1023 15:18:48.874528       1 shared_informer.go:372] The sharedIndexInformer has started, run more than once is not allowed
I1023 15:18:48.874542       1 tlsconfig.go:240] "Starting DynamicServingCertificateController"
I1023 15:18:48.874686       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file"
I1023 15:18:48.874695       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1023 15:18:48.874715       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::client-ca-file"
I1023 15:18:48.874720       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::client-ca-file
I1023 15:18:48.973530       1 shared_informer.go:247] Caches are synced for RequestHeaderAuthRequestController 
I1023 15:18:48.975770       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::client-ca-file 
I1023 15:18:48.975801       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file 

GitHub Copilot: The logs from the Metrics Server indicate that it is running without any critical errors. The server is generating self-signed certificates and starting various controllers successfully.

### Next Steps to Troubleshoot:

1. **Check APIService Status:**
   Ensure that the `v1beta1.metrics.k8s.io` APIService is available and healthy:
   ```sh
   kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
   ```
   Look for the `status` section to ensure it shows `Available: True`.

2. **Check Metrics Server Deployment:**
   Verify that the Metrics Server deployment is correctly configured:
   ```sh
   kubectl get deployment metrics-server -n kube-system -o yaml
   ```

3. **Check Network Policies:**
   Ensure there are no network policies blocking the Metrics Server from communicating with the kubelets.

4. **Check kubelet Configuration:**
   Ensure that the kubelets are configured to provide metrics:
   ```sh
   kubectl describe nodes | grep 'Kubelet Version'
   ```
   Ensure the kubelet version is compatible with the Metrics Server.

### Example Commands:

```sh
# Check APIService status
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml

# Check Metrics Server deployment
kubectl get deployment metrics-server -n kube-system -o yaml

# Check kubelet version
kubectl describe nodes | grep 'Kubelet Version'
```

If all configurations are correct and the issue persists, consider restarting the Metrics Server deployment:

```sh
kubectl rollout restart deployment metrics-server -n kube-system
```

These steps should help identify and resolve the issue with the Metrics API not being available.

rifaterdemsahin: why cant i reach the metrics server > @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get deployment metrics-server -n kube-system -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"metrics-server","namespace":"kube-system"},"spec":{"selector":{"matchLabels":{"k8s-app":"metrics-server"}},"template":{"metadata":{"labels":{"k8s-app":"metrics-server"}},"spec":{"containers":[{"args":["--kubelet-insecure-tls"],"image":"k8s.gcr.io/metrics-server/metrics-server:v0.6.2","name":"metrics-server","ports":[{"containerPort":443,"protocol":"TCP"}],"securityContext":{"runAsGroup":3000,"runAsUser":1000},"volumeMounts":[{"mountPath":"/apiserver.local.config","name":"tmp-cert-storage"}]}],"securityContext":{"fsGroup":2000},"volumes":[{"emptyDir":{},"name":"tmp-cert-storage"}]}}}}
  creationTimestamp: "2024-10-23T15:10:15Z"
  generation: 3
  name: metrics-server
  namespace: kube-system
  resourceVersion: "1482"
  uid: 19e72e56-69fb-4554-ae78-0e43b61416e5
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      k8s-app: metrics-server
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2024-10-23T15:23:39Z"
      creationTimestamp: null
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --kubelet-insecure-tls
        image: k8s.gcr.io/metrics-server/metrics-server:v0.6.2
        imagePullPolicy: IfNotPresent
        name: metrics-server
        ports:
        - containerPort: 443
          protocol: TCP
        resources: {}
        securityContext:
          runAsGroup: 3000
          runAsUser: 1000
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /apiserver.local.config
          name: tmp-cert-storage
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext:
        fsGroup: 2000
      serviceAccount: metrics-server
      serviceAccountName: metrics-server
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: tmp-cert-storage
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2024-10-23T15:18:48Z"
    lastUpdateTime: "2024-10-23T15:18:48Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2024-10-23T15:10:15Z"
    lastUpdateTime: "2024-10-23T15:23:41Z"
    message: ReplicaSet "metrics-server-6bb8bdd84c" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 1
  replicas: 1
  updatedReplicas: 1
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 

GitHub Copilot: The deployment configuration for the Metrics Server looks correct, and the status indicates that the Metrics Server pod is running and available. However, there are a few additional checks and configurations you can verify to ensure that you can reach the Metrics Server.

### Additional Checks:

1. **Check APIService Status:**
   Ensure that the `v1beta1.metrics.k8s.io` APIService is available and healthy:
   ```sh
   kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
   ```

2. **Check Network Policies:**
   Ensure there are no network policies blocking the Metrics Server from communicating with the kubelets.

3. **Check kubelet Configuration:**
   Ensure that the kubelets are configured to provide metrics:
   ```sh
   kubectl describe nodes | grep 'Kubelet Version'
   ```

4. **Check Metrics Server Logs Again:**
   Look for any additional errors or warnings in the logs:
   ```sh
   kubectl logs -n kube-system metrics-server-6f855c96bf-8h9ss
   ```

### Example Commands:

```sh
# Check APIService status
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml

# Check kubelet version
kubectl describe nodes | grep 'Kubelet Version'

# Check Metrics Server logs
kubectl logs -n kube-system metrics-server-6f855c96bf-8h9ss
```

### Restart Metrics Server Deployment:

If all configurations are correct and the issue persists, consider restarting the Metrics Server deployment:

```sh
kubectl rollout restart deployment metrics-server -n kube-system
```

### Example of Successful `kubectl top pods` Output:

```sh
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
NAME                               CPU(cores)   MEMORY(bytes)
coredns-6f6b679f8f-slm7x           2m           12Mi
etcd-minikube                      10m          50Mi
kube-apiserver-minikube            20m          100Mi
kube-controller-manager-minikube   5m           30Mi
kube-proxy-7lpg8                   1m           10Mi
kube-scheduler-minikube            3m           20Mi
metrics-server-6f855c96bf-8h9ss    1m           15Mi
storage-provisioner                2m           25Mi
```

These steps should help identify and resolve the issue with the Metrics API not being available.