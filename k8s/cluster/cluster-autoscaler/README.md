## Cluster Autoscaler
This resource automatically adjusts the size of the Kubernetes worker nodes ASG based on the demands of the running pods.

It will scale up the cluster when there are pods which can be scheduled due to lack of resources. And will scale down the cluster when detecs that there are under utilized nodes.
