@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
error: Metrics API not available
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 


```sh
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
error: Metrics API not available
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $
```

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