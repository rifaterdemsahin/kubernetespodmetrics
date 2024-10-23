@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ kubectl top pods
The connection to the server 192.168.49.2:8443 was refused - did you specify the right host or port?
@rifaterdemsahin ➜ /workspaces/kubernetespodmetrics (main) $ 

To solve this issue, you can try the following steps:

1. **Check Minikube Status**:
    Ensure that your Minikube cluster is running.
    ```sh
    minikube status
    ```

2. **Start Minikube**:
    If Minikube is not running, start it with:
    ```sh
    minikube start
    ```

3. **Set Kubernetes Context**:
    Ensure your kubectl context is set to Minikube.
    ```sh
    kubectl config use-context minikube
    ```

4. **Verify Connection**:
    Check if you can connect to the cluster.
    ```sh
    kubectl cluster-info
    ```

5. **Restart Minikube**:
    If the issue persists, try restarting Minikube.
    ```sh
    minikube stop
    minikube start
    ```

6. **Check Network Configuration**:
    Ensure there are no network issues or firewall rules blocking the connection.

If the problem continues, consult the Minikube and Kubernetes documentation for more detailed troubleshooting steps.