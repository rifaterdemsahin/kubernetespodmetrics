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

   @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get clusterrole system:metrics-server
NAME                    CREATED AT
system:metrics-server   2024-10-23T15:34:12Z

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get clusterrolebinding system:metrics-server
NAME                    ROLE                                AGE
system:metrics-server   ClusterRole/system:metrics-server   53s



3. **Check APIService status:**
   Ensure that the `v1beta1.metrics.k8s.io` APIService is available:
   ```sh
   kubectl get apiservice v1beta1.metrics.k8s.io
   ```
   The status should show `Available`.

   @rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $  kubectl get apiservice v1beta1.metrics.k8s.io
NAME                     SERVICE                      AVAILABLE                  AGE
v1beta1.metrics.k8s.io   kube-system/metrics-server   False (MissingEndpoints)   68s

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
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apiregistration.k8s.io/v1","kind":"APIService","metadata":{"annotations":{},"labels":{"k8s-app":"metrics-server"},"name":"v1beta1.metrics.k8s.io"},"spec":{"group":"metrics.k8s.io","groupPriorityMinimum":100,"insecureSkipTLSVerify":true,"service":{"name":"metrics-server","namespace":"kube-system"},"version":"v1beta1","versionPriority":100}}
  creationTimestamp: "2024-10-23T15:34:13Z"
  labels:
    k8s-app: metrics-server
  name: v1beta1.metrics.k8s.io
  resourceVersion: "636"
  uid: d60c1389-6da5-45d7-a1cd-a6e08828cd0a
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
  - lastTransitionTime: "2024-10-23T15:34:13Z"
    message: endpoints for service/metrics-server in "kube-system" have no addresses
      with port name "https"
    reason: MissingEndpoints
    status: "False"
    type: Available
   
   Look for the `status` section to ensure it shows `Available: True`.

2. **Check Metrics Server Deployment:**
   Verify that the Metrics Server deployment is correctly configured:
   ```sh
   kubectl get deployment metrics-server -n kube-system -o yaml
   ```

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get deployment metrics-server -n kube-system -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"labels":{"k8s-app":"metrics-server"},"name":"metrics-server","namespace":"kube-system"},"spec":{"selector":{"matchLabels":{"k8s-app":"metrics-server"}},"strategy":{"rollingUpdate":{"maxUnavailable":0}},"template":{"metadata":{"labels":{"k8s-app":"metrics-server"}},"spec":{"containers":[{"args":["--cert-dir=/tmp","--secure-port=10250","--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname","--kubelet-use-node-status-port","--metric-resolution=15s"],"image":"registry.k8s.io/metrics-server/metrics-server:v0.7.2","imagePullPolicy":"IfNotPresent","livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/livez","port":"https","scheme":"HTTPS"},"periodSeconds":10},"name":"metrics-server","ports":[{"containerPort":10250,"name":"https","protocol":"TCP"}],"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/readyz","port":"https","scheme":"HTTPS"},"initialDelaySeconds":20,"periodSeconds":10},"resources":{"requests":{"cpu":"100m","memory":"200Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}},"volumeMounts":[{"mountPath":"/tmp","name":"tmp-dir"}]}],"nodeSelector":{"kubernetes.io/os":"linux"},"priorityClassName":"system-cluster-critical","serviceAccountName":"metrics-server","volumes":[{"emptyDir":{},"name":"tmp-dir"}]}}}}
  creationTimestamp: "2024-10-23T15:31:27Z"
  generation: 3
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
  resourceVersion: "647"
  uid: 7b735397-d92d-4270-86aa-0e62652af93e
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
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2024-10-23T15:31:44Z"
      creationTimestamp: null
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=10250
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        image: registry.k8s.io/metrics-server/metrics-server:v0.7.2
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /livez
            port: https
            scheme: HTTPS
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: metrics-server
        ports:
        - containerPort: 10250
          name: https
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /readyz
            port: https
            scheme: HTTPS
          initialDelaySeconds: 20
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          requests:
            cpu: 100m
            memory: 200Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /tmp
          name: tmp-dir
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      priorityClassName: system-cluster-critical
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: metrics-server
      serviceAccountName: metrics-server
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: tmp-dir
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2024-10-23T15:31:33Z"
    lastUpdateTime: "2024-10-23T15:31:33Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2024-10-23T15:31:27Z"
    lastUpdateTime: "2024-10-23T15:34:13Z"
    message: ReplicaSet "metrics-server-7569858677" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 1
  replicas: 2
  unavailableReplicas: 1
  updatedReplicas: 1
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 

3. **Check Network Policies:**
   Ensure there are no network policies blocking the Metrics Server from communicating with the kubelets.

4. **Check kubelet Configuration:**
   Ensure that the kubelets are configured to provide metrics:
   ```sh
   kubectl describe nodes | grep 'Kubelet Version'
   ```
   Ensure the kubelet version is compatible with the Metrics Server.

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $    kubectl describe nodes | grep 'Kubelet Version'
  Kubelet Version:            v1.31.0

### Example Commands:

```sh
# Check APIService status
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apiregistration.k8s.io/v1","kind":"APIService","metadata":{"annotations":{},"labels":{"k8s-app":"metrics-server"},"name":"v1beta1.metrics.k8s.io"},"spec":{"group":"metrics.k8s.io","groupPriorityMinimum":100,"insecureSkipTLSVerify":true,"service":{"name":"metrics-server","namespace":"kube-system"},"version":"v1beta1","versionPriority":100}}
  creationTimestamp: "2024-10-23T15:34:13Z"
  labels:
    k8s-app: metrics-server
  name: v1beta1.metrics.k8s.io
  resourceVersion: "636"
  uid: d60c1389-6da5-45d7-a1cd-a6e08828cd0a
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
  - lastTransitionTime: "2024-10-23T15:34:13Z"
    message: endpoints for service/metrics-server in "kube-system" have no addresses
      with port name "https"
    reason: MissingEndpoints
    status: "False"
    type: Available

# Check Metrics Server deployment
kubectl get deployment metrics-server -n kube-system -o yaml

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get deployment metrics-server -n kube-system -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"labels":{"k8s-app":"metrics-server"},"name":"metrics-server","namespace":"kube-system"},"spec":{"selector":{"matchLabels":{"k8s-app":"metrics-server"}},"strategy":{"rollingUpdate":{"maxUnavailable":0}},"template":{"metadata":{"labels":{"k8s-app":"metrics-server"}},"spec":{"containers":[{"args":["--cert-dir=/tmp","--secure-port=10250","--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname","--kubelet-use-node-status-port","--metric-resolution=15s"],"image":"registry.k8s.io/metrics-server/metrics-server:v0.7.2","imagePullPolicy":"IfNotPresent","livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/livez","port":"https","scheme":"HTTPS"},"periodSeconds":10},"name":"metrics-server","ports":[{"containerPort":10250,"name":"https","protocol":"TCP"}],"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/readyz","port":"https","scheme":"HTTPS"},"initialDelaySeconds":20,"periodSeconds":10},"resources":{"requests":{"cpu":"100m","memory":"200Mi"}},"securityContext":{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}},"volumeMounts":[{"mountPath":"/tmp","name":"tmp-dir"}]}],"nodeSelector":{"kubernetes.io/os":"linux"},"priorityClassName":"system-cluster-critical","serviceAccountName":"metrics-server","volumes":[{"emptyDir":{},"name":"tmp-dir"}]}}}}
  creationTimestamp: "2024-10-23T15:31:27Z"
  generation: 3
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
  resourceVersion: "647"
  uid: 7b735397-d92d-4270-86aa-0e62652af93e
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
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      annotations:
        kubectl.kubernetes.io/restartedAt: "2024-10-23T15:31:44Z"
      creationTimestamp: null
      labels:
        k8s-app: metrics-server
    spec:
      containers:
      - args:
        - --cert-dir=/tmp
        - --secure-port=10250
        - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
        - --kubelet-use-node-status-port
        - --metric-resolution=15s
        image: registry.k8s.io/metrics-server/metrics-server:v0.7.2
        imagePullPolicy: IfNotPresent
        livenessProbe:
          failureThreshold: 3
          httpGet:
            path: /livez
            port: https
            scheme: HTTPS
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: metrics-server
        ports:
        - containerPort: 10250
          name: https
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /readyz
            port: https
            scheme: HTTPS
          initialDelaySeconds: 20
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          requests:
            cpu: 100m
            memory: 200Mi
        securityContext:
          allowPrivilegeEscalation: false
          capabilities:
            drop:
            - ALL
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1000
          seccompProfile:
            type: RuntimeDefault
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /tmp
          name: tmp-dir
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      priorityClassName: system-cluster-critical
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: metrics-server
      serviceAccountName: metrics-server
      terminationGracePeriodSeconds: 30
      volumes:
      - emptyDir: {}
        name: tmp-dir
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2024-10-23T15:31:33Z"
    lastUpdateTime: "2024-10-23T15:31:33Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2024-10-23T15:31:27Z"
    lastUpdateTime: "2024-10-23T15:34:13Z"
    message: ReplicaSet "metrics-server-7569858677" is progressing.
    reason: ReplicaSetUpdated
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 1
  replicas: 2
  unavailableReplicas: 1
  updatedReplicas: 1

# Check kubelet version
kubectl describe nodes | grep 'Kubelet Version'
```

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl describe nodes | grep 'Kubelet Version'
  Kubelet Version:            v1.31.0

If all configurations are correct and the issue persists, consider restarting the Metrics Server deployment:

```sh
kubectl rollout restart deployment metrics-server -n kube-system
```

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl rollout restart deployment metrics-server -n kube-system
deployment.apps/metrics-server restarted

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

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get endpoints metrics-server -n kube-system -o yaml
apiVersion: v1
kind: Endpoints
metadata:
  creationTimestamp: "2024-10-23T15:34:13Z"
  labels:
    k8s-app: metrics-server
  name: metrics-server
  namespace: kube-system
  resourceVersion: "895"
  uid: 68da0a7b-4e1c-40cd-ac57-44077a954850
subsets:
- notReadyAddresses:
  - ip: 10.244.0.6
    nodeName: minikube
    targetRef:
      kind: Pod
      name: metrics-server-7f4f56758-h8t4f
      namespace: kube-system
      uid: 39b5bda9-ebef-403b-b0ab-b9b8726452f0
  ports:
  - name: https
    port: 10250
    protocol: TCP

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

@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl get pods -n kube-system --selector=k8s-app=metrics-server -o yaml
apiVersion: v1
items:
- apiVersion: v1
  kind: Pod
  metadata:
    annotations:
      kubectl.kubernetes.io/restartedAt: "2024-10-23T15:37:58Z"
    creationTimestamp: "2024-10-23T15:37:58Z"
    generateName: metrics-server-7f4f56758-
    labels:
      k8s-app: metrics-server
      pod-template-hash: 7f4f56758
    name: metrics-server-7f4f56758-h8t4f
    namespace: kube-system
    ownerReferences:
    - apiVersion: apps/v1
      blockOwnerDeletion: true
      controller: true
      kind: ReplicaSet
      name: metrics-server-7f4f56758
      uid: 7c903ee0-e5d3-4d98-8b97-ee4bd3aedd1c
    resourceVersion: "894"
    uid: 39b5bda9-ebef-403b-b0ab-b9b8726452f0
  spec:
    containers:
    - args:
      - --cert-dir=/tmp
      - --secure-port=10250
      - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
      - --kubelet-use-node-status-port
      - --metric-resolution=15s
      image: registry.k8s.io/metrics-server/metrics-server:v0.7.2
      imagePullPolicy: IfNotPresent
      livenessProbe:
        failureThreshold: 3
        httpGet:
          path: /livez
          port: https
          scheme: HTTPS
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
      name: metrics-server
      ports:
      - containerPort: 10250
        name: https
        protocol: TCP
      readinessProbe:
        failureThreshold: 3
        httpGet:
          path: /readyz
          port: https
          scheme: HTTPS
        initialDelaySeconds: 20
        periodSeconds: 10
        successThreshold: 1
        timeoutSeconds: 1
      resources:
        requests:
          cpu: 100m
          memory: 200Mi
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop:
          - ALL
        readOnlyRootFilesystem: true
        runAsNonRoot: true
        runAsUser: 1000
        seccompProfile:
          type: RuntimeDefault
      terminationMessagePath: /dev/termination-log
      terminationMessagePolicy: File
      volumeMounts:
      - mountPath: /tmp
        name: tmp-dir
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-x7m9z
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: minikube
    nodeSelector:
      kubernetes.io/os: linux
    preemptionPolicy: PreemptLowerPriority
    priority: 2000000000
    priorityClassName: system-cluster-critical
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext: {}
    serviceAccount: metrics-server
    serviceAccountName: metrics-server
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
      key: node.kubernetes.io/not-ready
      operator: Exists
      tolerationSeconds: 300
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
      tolerationSeconds: 300
    volumes:
    - emptyDir: {}
      name: tmp-dir
    - name: kube-api-access-x7m9z
      projected:
        defaultMode: 420
        sources:
        - serviceAccountToken:
            expirationSeconds: 3607
            path: token
        - configMap:
            items:
            - key: ca.crt
              path: ca.crt
            name: kube-root-ca.crt
        - downwardAPI:
            items:
            - fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
              path: namespace
  status:
    conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:38:00Z"
      status: "True"
      type: PodReadyToStartContainers
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:37:58Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:37:58Z"
      message: 'containers with unready status: [metrics-server]'
      reason: ContainersNotReady
      status: "False"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:37:58Z"
      message: 'containers with unready status: [metrics-server]'
      reason: ContainersNotReady
      status: "False"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:37:58Z"
      status: "True"
      type: PodScheduled
    containerStatuses:
    - containerID: docker://3d71f619540ab813e67f350b761b1336e9554ba67b82a3f644bafd36dc86ae86
      image: registry.k8s.io/metrics-server/metrics-server:v0.7.2
      imageID: docker-pullable://registry.k8s.io/metrics-server/metrics-server@sha256:ffcb2bf004d6aa0a17d90e0247cf94f2865c8901dcab4427034c341951c239f9
      lastState: {}
      name: metrics-server
      ready: false
      restartCount: 0
      started: true
      state:
        running:
          startedAt: "2024-10-23T15:38:00Z"
      volumeMounts:
      - mountPath: /tmp
        name: tmp-dir
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-x7m9z
        readOnly: true
        recursiveReadOnly: Disabled
    hostIP: 192.168.49.2
    hostIPs:
    - ip: 192.168.49.2
    phase: Running
    podIP: 10.244.0.6
    podIPs:
    - ip: 10.244.0.6
    qosClass: Burstable
    startTime: "2024-10-23T15:37:58Z"
- apiVersion: v1
  kind: Pod
  metadata:
    annotations:
      kubectl.kubernetes.io/restartedAt: "2024-10-23T15:31:44Z"
    creationTimestamp: "2024-10-23T15:31:44Z"
    generateName: metrics-server-8b69cc6d8-
    labels:
      k8s-app: metrics-server
      pod-template-hash: 8b69cc6d8
    name: metrics-server-8b69cc6d8-5q5c7
    namespace: kube-system
    ownerReferences:
    - apiVersion: apps/v1
      blockOwnerDeletion: true
      controller: true
      kind: ReplicaSet
      name: metrics-server-8b69cc6d8
      uid: 7b8ff5b3-668b-4470-853f-86ef6a2e2093
    resourceVersion: "489"
    uid: 7942f312-6b46-49bd-abd0-2c0bd9c921d5
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
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-zd588
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    nodeName: minikube
    preemptionPolicy: PreemptLowerPriority
    priority: 0
    restartPolicy: Always
    schedulerName: default-scheduler
    securityContext:
      fsGroup: 2000
    serviceAccount: default
    serviceAccountName: default
    terminationGracePeriodSeconds: 30
    tolerations:
    - effect: NoExecute
      key: node.kubernetes.io/not-ready
      operator: Exists
      tolerationSeconds: 300
    - effect: NoExecute
      key: node.kubernetes.io/unreachable
      operator: Exists
      tolerationSeconds: 300
    volumes:
    - emptyDir: {}
      name: tmp-cert-storage
    - name: kube-api-access-zd588
      projected:
        defaultMode: 420
        sources:
        - serviceAccountToken:
            expirationSeconds: 3607
            path: token
        - configMap:
            items:
            - key: ca.crt
              path: ca.crt
            name: kube-root-ca.crt
        - downwardAPI:
            items:
            - fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
              path: namespace
  status:
    conditions:
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:31:46Z"
      status: "True"
      type: PodReadyToStartContainers
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:31:44Z"
      status: "True"
      type: Initialized
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:31:46Z"
      status: "True"
      type: Ready
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:31:46Z"
      status: "True"
      type: ContainersReady
    - lastProbeTime: null
      lastTransitionTime: "2024-10-23T15:31:44Z"
      status: "True"
      type: PodScheduled
    containerStatuses:
    - containerID: docker://8527b08723c37469fd87ba08122ac0415d65293d8a020b829fd3cde5ce756310
      image: k8s.gcr.io/metrics-server/metrics-server:v0.6.2
      imageID: docker-pullable://k8s.gcr.io/metrics-server/metrics-server@sha256:f977ad859fb500c1302d9c3428c6271db031bb7431e7076213b676b345a88dc2
      lastState: {}
      name: metrics-server
      ready: true
      restartCount: 0
      started: true
      state:
        running:
          startedAt: "2024-10-23T15:31:45Z"
      volumeMounts:
      - mountPath: /apiserver.local.config
        name: tmp-cert-storage
      - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-zd588
        readOnly: true
        recursiveReadOnly: Disabled
    hostIP: 192.168.49.2
    hostIPs:
    - ip: 192.168.49.2
    phase: Running
    podIP: 10.244.0.4
    podIPs:
    - ip: 10.244.0.4
    qosClass: BestEffort
    startTime: "2024-10-23T15:31:44Z"
kind: List
metadata:
  resourceVersion: ""
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (

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