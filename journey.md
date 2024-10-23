graph TD
    A[imaginary.md - Oct 23 15:06] --> B[realjob.md - Oct 23 15:07]
    B --> C[formula.md - Oct 23 15:08]
    C --> D[symbolic.md - Oct 23 15:08]
    D --> E[semblance.md - Oct 23 15:10]
    E --> F1[semblance_error_after_install.png - Oct 23 15:10]
    E --> G[journey.md - Oct 23 15:11]
    G --> G1[journey_output.png - Oct 23 15:12]
    F1 --> H[semblance_error_after_restart.md - Oct 23 15:13]
    H --> I[semblance_multi_stages.png - Oct 23 15:17]
    C --> J[formula_running_pods.md - Oct 23 15:21]
    J --> K[formula_debug_metrics_server.md - Oct 23 15:23]
    K --> L[formula_metrics_server_desribe.md - Oct 23 15:25]
    L --> M[semblance_service_debug.md - Oct 23 15:26]
    M --> N[formula_get_endpoints.md - Oct 23 15:27]
    N --> O[formula_kubesystem_logs.md - Oct 23 15:30]
    O --> P[symbol-metric-server.yaml - Oct 23 15:30]
    P --> Q[symbolic-execute.sh - Oct 23 15:31]
    M --> R[semblance_ai_composer_all.md - Oct 23 15:39]
    R --> S[semblance_edit.md - Oct 23 16:00]
    S --> T1[semblance_deployment_edit_happiness.png - Oct 23 16:04]
    T1 --> T2[realResult.png - Oct 23 16:04]
    S --> U1[semblance_solve_by_edit.png - Oct 23 16:07]
    U1 --> U2[semblance_insecure_tls.png - Oct 23 16:08]

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

rifaterdemsahin: how dio i solve > @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $   kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
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

GitHub Copilot: The error message `endpoints for service/metrics-server in "kube-system" have no addresses with port name "https"` indicates that the Metrics Server service does not have any endpoints associated with it. This usually means that the service is not correctly pointing to the Metrics Server pods.

### Steps to Resolve:

1. **Check the Metrics Server Service:**
   Ensure that the service is correctly configured and points to the Metrics Server pods.

   ```sh
   kubectl get service metrics-server -n kube-system -o yaml
   ```

2. **Check Endpoints:**
   Verify that the endpoints for the Metrics Server service are correctly set up.

   ```sh
   kubectl get endpoints metrics-server -n kube-system -o yaml
   ```

3. **Ensure Pod Labels Match Service Selector:**
   Ensure that the labels on the Metrics Server pods match the selector specified in the service.

   ```sh
   kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
   ```

### Example Commands and Expected Outputs:

#### Check Metrics Server Service:
```sh
kubectl get service metrics-server -n kube-system -o yaml
```

Expected output should include:
```yaml
spec:
  selector:
    k8s-app: metrics-server
```

#### Check Endpoints:
```sh
kubectl get endpoints metrics-server -n kube-system -o yaml
```

Expected output should include addresses:
```yaml
subsets:
  - addresses:
      - ip: <Metrics Server Pod IP>
    ports:
      - port: 443
        protocol: TCP
```

#### Ensure Pod Labels Match Service Selector:
```sh
kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
```

Expected output should include:
```yaml
metadata:
  labels:
    k8s-app: metrics-server
```

### Fixing the Issue:

1. **If the service selector does not match the pod labels:**
   Update the service to match the pod labels.

   ```sh
   kubectl edit service metrics-server -n kube-system
   ```

   Ensure the `selector` field matches the pod labels:
   ```yaml
   spec:
     selector:
       k8s-app: metrics-server
   ```

2. **If there are no endpoints:**
   Ensure the pods are running and have the correct labels. If necessary, restart the Metrics Server deployment:

   ```sh
   kubectl rollout restart deployment metrics-server -n kube-system
   ```

These steps should help resolve the issue with the Metrics Server endpoints and make the Metrics API available.

rifaterdemsahin: why cant i connect > @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl logs -n kube-system metrics-server-6bb8bdd84c-tvxj7
I1023 15:23:41.362235       1 serving.go:342] Generated self-signed cert (apiserver.local.config/certificates/apiserver.crt, apiserver.local.config/certificates/apiserver.key)
I1023 15:23:41.905650       1 requestheader_controller.go:169] Starting RequestHeaderAuthRequestController
I1023 15:23:41.905669       1 shared_informer.go:240] Waiting for caches to sync for RequestHeaderAuthRequestController
I1023 15:23:41.905732       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::client-ca-file"
I1023 15:23:41.905750       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::client-ca-file
I1023 15:23:41.905771       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file"
I1023 15:23:41.905777       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1023 15:23:41.905968       1 secure_serving.go:266] Serving securely on [::]:443
I1023 15:23:41.906044       1 dynamic_serving_content.go:131] "Starting controller" name="serving-cert::apiserver.local.config/certificates/apiserver.crt::apiserver.local.config/certificates/apiserver.key"
I1023 15:23:41.906398       1 tlsconfig.go:240] "Starting DynamicServingCertificateController"
W1023 15:23:41.906523       1 shared_informer.go:372] The sharedIndexInformer has started, run more than once is not allowed
I1023 15:23:42.006585       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file 
I1023 15:23:42.006642       1 shared_informer.go:247] Caches are synced for RequestHeaderAuthRequestController 
I1023 15:23:42.006728       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::client-ca-file 
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 

GitHub Copilot: The logs indicate that the Metrics Server is running and serving securely on port 443. However, the `kubectl get apiservice v1beta1.metrics.k8s.io -o yaml` output shows that the APIService is not available due to missing endpoints.

### Steps to Resolve:

1. **Check Metrics Server Service:**
   Ensure that the service is correctly configured and points to the Metrics Server pods.

   ```sh
   kubectl get service metrics-server -n kube-system -o yaml
   ```

2. **Check Endpoints:**
   Verify that the endpoints for the Metrics Server service are correctly set up.

   ```sh
   kubectl get endpoints metrics-server -n kube-system -o yaml
   ```

3. **Ensure Pod Labels Match Service Selector:**
   Ensure that the labels on the Metrics Server pods match the selector specified in the service.

   ```sh
   kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
   ```

### Example Commands and Expected Outputs:

#### Check Metrics Server Service:
```sh
kubectl get service metrics-server -n kube-system -o yaml
```

Expected output should include:
```yaml
spec:
  selector:
    k8s-app: metrics-server
```

#### Check Endpoints:
```sh
kubectl get endpoints metrics-server -n kube-system -o yaml
```

Expected output should include addresses:
```yaml
subsets:
  - addresses:
      - ip: <Metrics Server Pod IP>
    ports:
      - port: 443
        protocol: TCP
```

#### Ensure Pod Labels Match Service Selector:
```sh
kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
```

Expected output should include:
```yaml
metadata:
  labels:
    k8s-app: metrics-server
```

### Fixing the Issue:

1. **If the service selector does not match the pod labels:**
   Update the service to match the pod labels.

   ```sh
   kubectl edit service metrics-server -n kube-system
   ```

   Ensure the `selector` field matches the pod labels:
   ```yaml
   spec:
     selector:
       k8s-app: metrics-server
   ```

2. **If there are no endpoints:**
   Ensure the pods are running and have the correct labels. If necessary, restart the Metrics Server deployment:

   ```sh
   kubectl rollout restart deployment metrics-server -n kube-system
   ```

These steps should help resolve the issue with the Metrics Server endpoints and make the Metrics API available.

rifaterdemsahin: solve kubectl top pods 

GitHub Copilot: To solve the issue with `kubectl top pods` not working, follow these steps:

### 1. Verify Metrics Server Service Configuration
Ensure that the Metrics Server service is correctly configured and points to the Metrics Server pods.

```sh
kubectl get service metrics-server -n kube-system -o yaml
```

Expected output should include:
```yaml
spec:
  selector:
    k8s-app: metrics-server
```

### 2. Verify Endpoints
Check that the endpoints for the Metrics Server service are correctly set up.

```sh
kubectl get endpoints metrics-server -n kube-system -o yaml
```

Expected output should include addresses:
```yaml
subsets:
  - addresses:
      - ip: <Metrics Server Pod IP>
    ports:
      - port: 443
        protocol: TCP
```

### 3. Ensure Pod Labels Match Service Selector
Ensure that the labels on the Metrics Server pods match the selector specified in the service.

```sh
kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
```

Expected output should include:
```yaml
metadata:
  labels:
    k8s-app: metrics-server
```

### 4. Check APIService Status
Ensure that the `v1beta1.metrics.k8s.io` APIService is available and healthy.

```sh
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```

Expected output should show `Available: True`:
```yaml
status:
  conditions:
  - lastTransitionTime: "2024-10-23T15:10:15Z"
    message: all checks passed
    reason: Passed
    status: "True"
    type: Available
```

### 5. Restart Metrics Server Deployment
If all configurations are correct and the issue persists, restart the Metrics Server deployment.

```sh
kubectl rollout restart deployment metrics-server -n kube-system
```

### 6. Verify Network Policies
Ensure there are no network policies blocking the Metrics Server from communicating with the kubelets.

### Example Commands to Run:
```sh
# Check Metrics Server service
kubectl get service metrics-server -n kube-system -o yaml

# Check Metrics Server endpoints
kubectl get endpoints metrics-server -n kube-system -o yaml

# Ensure pod labels match service selector
kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml

# Check APIService status
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml

# Restart Metrics Server deployment
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

These steps should help resolve the issue with the Metrics Server and make the `kubectl top pods` command work correctly.

rifaterdemsahin: @terminal /explain #terminalSelection

Terminal: The `ls` command does not support `--time=creation`. Instead, you can use `--time=ctime` to sort files by their inode change time (ctime).

Here is the corrected command:

```bash
ls -lt --time=ctime
```

This will list the files in the current directory sorted by the inode change time.

rifaterdemsahin: reverse sort

GitHub Copilot: To reverse sort the files by their inode change time (ctime), you can add the `-r` option to the `ls` command:

```bash
ls -ltr --time=ctime
```

This will list the files in the current directory sorted by their inode change time in reverse order.

rifaterdemsahin: Explain story of the journey how did i create the project 

GitHub Copilot: The journey of your project creation is well-documented through a series of interconnected files and steps, as illustrated in the 

journey.md

 file. Here's a step-by-step breakdown of the process:

1. **Starting Point:**
   - **imaginary.md (Oct 23 15:06):** This file likely contains initial ideas or a conceptual overview of the project.

2. **Defining Objectives:**
   - **realjob.md (Oct 23 15:07):** Here, you defined the objective of monitoring and analyzing Kubernetes pod metrics to ensure optimal resource utilization and application performance.

3. **Setting Up the Environment:**
   - **formula.md (Oct 23 15:08):** You started setting up Minikube and other necessary tools.
   - **symbolic.md (Oct 23 15:08):** This file includes commands like `kubectl top pods` to check pod metrics.

4. **Deployment and Configuration:**
   - **semblance.md (Oct 23 15:10):** You documented the deployment process and initial configurations.
   - **symbol-metric-server.yaml (Oct 23 15:30):** This YAML file defines the deployment of the Metrics Server in your Kubernetes cluster.
   - **symbolic-execute.sh (Oct 23 15:31):** A script to apply the Metrics Server configuration and check pod metrics.

5. **Troubleshooting and Debugging:**
   - **semblance_error_after_install.png (Oct 23 15:10):** Captured an error encountered after installation.
   - **semblance_error_after_restart.md (Oct 23 15:13):** Documented errors after restarting the system.
   - **formula_debug_metrics_server.md (Oct 23 15:23):** Debugging steps for the Metrics Server.
   - **formula_metrics_server_desribe.md (Oct 23 15:25):** Detailed description of the Metrics Server deployment.
   - **semblance_service_debug.md (Oct 23 15:26):** Further debugging steps for the service.

6. **Verification and Validation:**
   - **formula_running_pods.md (Oct 23 15:21):** Verified running pods.
   - **formula_get_endpoints.md (Oct 23 15:27):** Checked endpoints.
   - **formula_kubesystem_logs.md (Oct 23 15:30):** Analyzed logs from the kube-system namespace.

7. **Final Adjustments and Results:**
   - **semblance_ai_composer_all.md (Oct 23 15:39):** Comprehensive documentation of all steps and checks.
   - **semblance_edit.md (Oct 23 16:00):** Final edits and adjustments.
   - **semblance_deployment_edit_happiness.png (Oct 23 16:04):** Captured successful deployment.
   - **realResult.png (Oct 23 16:04):** Final result image showing successful metrics collection.
   - **semblance_solve_by_edit.png (Oct 23 16:07):** Solution through edits.
   - **semblance_insecure_tls.png (Oct 23 16:08):** Addressed insecure TLS issues.

Throughout this journey, you meticulously documented each step, from initial setup to final validation, ensuring a comprehensive and well-organized project creation process.