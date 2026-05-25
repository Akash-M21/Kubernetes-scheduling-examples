# Kubernetes Scheduling Examples

A hands-on Kubernetes project demonstrating how Pods are scheduled across nodes using different Kubernetes scheduling mechanisms.

This repository provides practical examples for understanding:

- Node Selector
- Node Affinity
- Node Anti-Affinity
- Pod Affinity
- Pod Anti-Affinity

These concepts are important for:
- workload placement
- high availability
- resource optimization
- GPU scheduling
- low-latency applications
- production-grade Kubernetes deployments

The project is designed for:
- Kubernetes beginners
- DevOps engineers
- CKA preparation
- hands-on Kubernetes practice

---

# 📚 Topics Covered

| Feature | Description |
|---|---|
| nodeSelector | Simplest way to schedule Pods onto labeled nodes |
| nodeAffinity | Advanced node-based scheduling using flexible matching rules |
| podAffinity | Places Pods together on the same node or topology |
| podAntiAffinity | Spreads Pods across nodes for high availability |
| topologyKey | Defines the topology boundary used for scheduling |

---

# 🏗 Project Structure

```text
Kubernetes-scheduling-examples/
│
├── README.md
│
├── manifests/
│   ├── base-deployment.yaml
│   ├── node-selector.yaml
│   ├── node-affinity.yaml
│   ├── node-anti-affinity.yaml
│   ├── pod-affinity.yaml
│   ├── pod-anti-affinity.yaml
│   └── database-pod.yaml
│
└── commands/
    ├── apply.sh
    └── cleanup.sh
```

---

# 🚀 Prerequisites

Before starting, ensure you have:

- A Kubernetes cluster
- kubectl installed and configured
- Minimum 2 worker nodes recommended
- Basic understanding of Pods and Deployments

Verify your cluster:

```bash
kubectl get nodes
```

---

# ⚙️ Setup

## Clone Repository

```bash
git clone https://github.com/<your-username>/Kubernetes-scheduling-examples.git
```

## Navigate to Project

```bash
cd Kubernetes-scheduling-examples
```

---

# 🧠 Understanding Kubernetes Scheduling

The Kubernetes Scheduler decides which node should run a Pod.

By default:
- Kubernetes places Pods on any available node
- the scheduler tries to balance workloads automatically

However, in production environments we often need more control.

Examples:
- Run GPU workloads only on GPU nodes
- Keep application Pods close to database Pods
- Spread replicas across nodes for high availability
- Prevent workloads from running on expensive nodes

Kubernetes provides several scheduling mechanisms to solve these problems.

---

# 1️⃣ Base Deployment

## File

```text
manifests/base-deployment.yaml
```

## Purpose

This is a basic Deployment without any scheduling constraints.

The Kubernetes scheduler can place Pods on any available node in the cluster.

This example helps understand the default Kubernetes scheduling behavior.

## Apply

```bash
kubectl apply -f manifests/base-deployment.yaml
```

## Use Cases

- Default workloads
- Stateless applications
- Simple Kubernetes deployments

## Limitations

- No control over Pod placement
- Scheduler decides placement automatically

---

# 2️⃣ Node Selector

## File

```text
manifests/node-selector.yaml
```

## Purpose

`nodeSelector` is the simplest scheduling mechanism in Kubernetes.

It schedules Pods only onto nodes that contain specific labels.

In this example:

```yaml
nodeSelector:
  gpu: "true"
```

Pods are allowed to run only on nodes labeled:

```text
gpu=true
```

---

## Add Label to Node

```bash
kubectl label nodes node1 gpu=true
```

## Verify Labels

```bash
kubectl get nodes --show-labels
```

## Apply

```bash
kubectl apply -f manifests/node-selector.yaml
```

---

## ✅ Advantages

- Very simple
- Easy to configure
- Beginner friendly
- Good for small clusters

## ❌ Limitations

- Exact matching only
- Cannot use advanced conditions
- Not flexible for complex environments

## ✅ Use Cases

- GPU workloads
- Dedicated hardware nodes
- Learning Kubernetes scheduling

---

# 3️⃣ Node Affinity

## File

```text
manifests/node-affinity.yaml
```

## Purpose

Node Affinity is a more advanced version of nodeSelector.

It allows flexible scheduling rules using operators.

In this example:

```yaml
operator: In
```

Pods are scheduled only on nodes labeled:

```text
gpu=true
```

---

## Supported Operators

| Operator | Description |
|---|---|
| In | Label value must match |
| NotIn | Label value must not match |
| Exists | Label key must exist |
| DoesNotExist | Label key must not exist |
| Gt | Greater than |
| Lt | Less than |

---

## Apply

```bash
kubectl apply -f manifests/node-affinity.yaml
```

---

## ✅ Advantages

- More flexible than nodeSelector
- Production-ready
- Supports complex scheduling logic

## ❌ Limitations

- More difficult to understand
- Harder to debug

## ✅ Use Cases

- Production scheduling
- Multi-node clusters
- Specialized hardware scheduling

---

# 4️⃣ Node Anti-Affinity

## File

```text
manifests/node-anti-affinity.yaml
```

## Purpose

This example avoids scheduling Pods on GPU nodes.

Implemented using:

```yaml
operator: NotIn
```

This tells Kubernetes:

> Do NOT place Pods on nodes labeled gpu=true

---

## Important Note

Kubernetes does not provide a dedicated:

```yaml
nodeAntiAffinity:
```

field.

Instead, anti-affinity behavior is implemented using:

```yaml
nodeAffinity:
```

with:

```yaml
operator: NotIn
```

---

## Apply

```bash
kubectl apply -f manifests/node-anti-affinity.yaml
```

---

## ✅ Advantages

- Prevents workloads from using specialized nodes
- Better workload isolation
- Helps optimize expensive resources

## ❌ Limitations

- Requires proper labeling strategy

## ✅ Use Cases

- Avoid GPU nodes
- Keep lightweight workloads on normal nodes
- Reserve hardware for critical applications

---

# 5️⃣ Pod Affinity

## File

```text
manifests/pod-affinity.yaml
```

## Purpose

Pod Affinity schedules Pods close to other Pods.

In this example:

```yaml
app=database
```

The scheduler places Pods on the SAME node where database Pods are already running.

This is controlled using:

```yaml
topologyKey: kubernetes.io/hostname
```

which means:
- apply the rule at node level

---

## Why Pod Affinity is Useful

Keeping related applications together can:
- reduce network latency
- improve communication speed
- improve application performance

Example:
- application + database
- backend + cache

---

## Important

Create the database Pod first:

```bash
kubectl apply -f manifests/database-pod.yaml
```

Otherwise affinity Pods remain in:

```text
Pending
```

state because Kubernetes cannot find matching Pods.

---

## Apply

```bash
kubectl apply -f manifests/pod-affinity.yaml
```

---

## ✅ Advantages

- Faster communication
- Better local access
- Reduced network overhead

## ❌ Limitations

- Can overload nodes
- Reduces scheduling flexibility

## ✅ Use Cases

- App + Database
- App + Redis Cache
- Closely connected services

---

# 6️⃣ Pod Anti-Affinity

## File

```text
manifests/pod-anti-affinity.yaml
```

## Purpose

Pod Anti-Affinity spreads Pods across nodes.

It prevents Pods from running together on the same node.

This improves:
- fault tolerance
- high availability
- resilience

If one node fails:
- not all replicas are affected

---

## Apply

```bash
kubectl apply -f manifests/pod-anti-affinity.yaml
```

---

## ✅ Advantages

- Better high availability
- Improved reliability
- Replica spreading

## ❌ Limitations

- Requires multiple worker nodes
- Pods may remain Pending in small clusters

## ✅ Use Cases

- Production applications
- HA deployments
- Critical workloads

---

# 🔍 Verification Commands

## Check Pod Placement

```bash
kubectl get pods -o wide
```

## Check Node Labels

```bash
kubectl get nodes --show-labels
```

## Describe Pod

```bash
kubectl describe pod <pod-name>
```

---

# 📌 Example Output

```bash
kubectl get pods -o wide
```

| POD | NODE |
|---|---|
| database-pod | node1 |
| gpu-app-pod-affinity | node1 |

This confirms Pod Affinity is working correctly.

---

# 🧠 Important Kubernetes Concepts

## requiredDuringSchedulingIgnoredDuringExecution

| Term | Meaning |
|---|---|
| requiredDuringScheduling | Rule MUST match before scheduling |
| IgnoredDuringExecution | Running Pods are NOT evicted if labels later change |

Example:
- Pod scheduled on gpu=true node
- later label removed
- Pod continues running

---

# 🌍 topologyKey Explained

```yaml
topologyKey: kubernetes.io/hostname
```

This defines the scheduling boundary.

Other examples:

| topologyKey | Meaning |
|---|---|
| kubernetes.io/hostname | Node |
| topology.kubernetes.io/zone | Availability Zone |
| topology.kubernetes.io/region | Region |

---

# 🛠 Apply All Resources

## Using Script

```bash
chmod +x commands/apply.sh
./commands/apply.sh
```

---

# 🧹 Cleanup Resources

```bash
chmod +x commands/cleanup.sh
./commands/cleanup.sh
```

---

# 🚨 Troubleshooting

## Pods Stuck in Pending

### Cause

Affinity rule not satisfied.

### Fix

```bash
kubectl apply -f manifests/database-pod.yaml
```

---

## Node Label Missing

### Verify

```bash
kubectl get nodes --show-labels
```

### Add Label

```bash
kubectl label nodes node1 gpu=true
```

---

## Check Scheduler Events

```bash
kubectl describe pod <pod-name>
```

---

# 🎯 Learning Outcomes

After completing this project, you will understand:

- Kubernetes scheduler basics
- Node labels and selectors
- Affinity and anti-affinity
- Pod placement strategies
- High availability scheduling
- topologyKey behavior
- Real-world Kubernetes scheduling scenarios

---

# 🔥 Future Improvements

You can extend this project with:

- Taints & Tolerations
- Topology Spread Constraints
- StatefulSets
- Resource Limits
- GPU Scheduling
- Multi-zone Scheduling

---

# 📖 References

- Kubernetes Official Documentation
- Kubernetes Scheduling Documentation
- Kubernetes Affinity Documentation

---

# ⭐ Author

Akash M
