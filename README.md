# Kubernetes Scheduling & Affinity examples

A hands-on Kubernetes project demonstrating:

- Node Selector
- Node Affinity
- Node Anti-Affinity
- Pod Affinity
- Pod Anti-Affinity

This project helps understand how Kubernetes schedules Pods across nodes using labels and affinity rules.

---

# 📚 Topics Covered

| Feature | Purpose |
|---|---|
| nodeSelector | Schedule Pods on specific labeled nodes |
| nodeAffinity | Advanced node-based scheduling |
| podAffinity | Place Pods together |
| podAntiAffinity | Separate Pods across nodes |
| topologyKey | Defines scheduling topology boundary |

---

# 🏗 Project Structure

```text
kubernetes-scheduling-lab/
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
├── commands/
    ├── apply.sh
    └── cleanup.sh
```

---

# 🚀 Pre-requisites

- Kubernetes Cluster
- kubectl installed
- Minimum 2 worker nodes recommended

Verify cluster:

```bash
kubectl get nodes
```

---

# 1️⃣ Base Deployment

## File

```text
manifests/base-deployment.yaml
```

## Purpose

Basic Deployment without any scheduling rules.

Pods can run on any available node.

## Apply

```bash
kubectl apply -f manifests/base-deployment.yaml
```

---

# 2️⃣ Node Selector

## File

```text
manifests/node-selector.yaml
```

## Purpose

Schedules Pods only on nodes having:

```text
gpu=true
```

## Add Label

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

# ✅ Advantages

- Very simple
- Easy to understand
- Good for small clusters

# ❌ Limitations

- Limited flexibility
- Supports exact matches only
- Cannot use complex conditions

# ✅ Use When

- Small environments
- Simple node targeting
- Learning Kubernetes scheduling

# ❌ Avoid When

- Large production clusters
- Complex scheduling requirements

---

# 3️⃣ Node Affinity

## File

```text
manifests/node-affinity.yaml
```

## Purpose

Advanced node scheduling using affinity rules.

Pods run only on nodes labeled:

```text
gpu=true
```

using:

```yaml
operator: In
```

---

# ✅ Advantages

- Flexible scheduling
- Supports operators:
  - In
  - NotIn
  - Exists
  - DoesNotExist
  - Gt
  - Lt

- Production-ready

# ❌ Limitations

- More complex than nodeSelector
- Harder to debug

# ✅ Use When

- Production environments
- Advanced scheduling policies
- Multi-node clusters

# ❌ Avoid When

- Simple learning demos
- Tiny clusters

---

# 4️⃣ Node Anti-Affinity

## File

```text
manifests/node-anti-affinity.yaml
```

## Purpose

Avoid scheduling Pods on nodes labeled:

```text
gpu=true
```

Implemented using:

```yaml
operator: NotIn
```

---

# ⚠ Important Note

Kubernetes does NOT have a dedicated:

```yaml
nodeAntiAffinity:
```

field.

Anti-affinity behavior is achieved using:

```yaml
nodeAffinity:
```

with:

```yaml
operator: NotIn
```

---

# ✅ Advantages

- Avoid expensive/specialized nodes
- Better resource separation

# ❌ Limitations

- Requires careful label management

# ✅ Use When

- Keeping workloads away from GPU nodes
- Avoiding noisy neighbors

---

# 5️⃣ Pod Affinity

## File

```text
manifests/pod-affinity.yaml
```

## Purpose

Schedules Pods on the SAME node as Pods labeled:

```text
app=database
```

using:

```yaml
topologyKey: kubernetes.io/hostname
```

---

# ⚠ Important

You MUST create the database Pod first.

Apply:

```bash
kubectl apply -f manifests/database-pod.yaml
```

Otherwise Pods remain:

```text
Pending
```

---

# ✅ Advantages

- Reduces network latency
- Improves inter-service communication
- Useful for tightly coupled services

# ❌ Limitations

- Can reduce cluster flexibility
- Risk of node congestion

# ✅ Use When

- App + cache
- App + database
- High-speed local communication needed

# ❌ Avoid When

- High availability is more important
- Large distributed systems

---

# 6️⃣ Pod Anti-Affinity

## File

```text
manifests/pod-anti-affinity.yaml
```

## Purpose

Prevents Pods from running on the same node.

Useful for high availability.

---

# ✅ Advantages

- Better fault tolerance
- High availability
- Spreads replicas across nodes

# ❌ Limitations

- Requires enough worker nodes
- Scheduling can fail in small clusters

# ✅ Use When

- Critical production workloads
- Replica spreading
- HA systems

# ❌ Avoid When

- Single-node clusters
- Resource-constrained environments

---

# 🔍 Verify Pod Placement

```bash
kubectl get pods -o wide
```

Example:

| POD | NODE |
|---|---|
| database-pod | node1 |
| gpu-app-pod-affinity | node1 |

---

# 🧠 Important Kubernetes Concepts

## requiredDuringSchedulingIgnoredDuringExecution

Meaning:

| Part | Explanation |
|---|---|
| requiredDuringScheduling | Rule MUST match before scheduling |
| IgnoredDuringExecution | Running Pods are NOT evicted if labels later change |

---

# 📌 topologyKey Explained

```yaml
topologyKey: kubernetes.io/hostname
```

Means:
- apply rule at node level

Other examples:

| Topology Key | Meaning |
|---|---|
| kubernetes.io/hostname | Node |
| topology.kubernetes.io/zone | Availability Zone |
| topology.kubernetes.io/region | Region |

---

# 🧪 Useful Commands

## Check Nodes

```bash
kubectl get nodes
```

## Check Labels

```bash
kubectl get nodes --show-labels
```

## Describe Pod

```bash
kubectl describe pod <pod-name>
```

## View Scheduling Events

```bash
kubectl describe pod <pod-name>
```

---

# 🟢 Cleanup

```bash
kubectl delete -f manifests/
```

---

# 📷 Suggested Screenshots

Add screenshots for:

- Node labels
- Pod placement
- Pending Pods
- Pod affinity working
- Anti-affinity spreading
```

---

# 🎯 Learning Outcomes

After completing this lab, you will understand:

- Kubernetes scheduler basics
- Node selection
- Affinity rules
- Anti-affinity behavior
- Topology-based scheduling
- High availability scheduling patterns

---

# 📖 References

- Kubernetes Official Documentation
- Kubernetes Scheduling Concepts
- Kubernetes Affinity & Anti-Affinity

---

# ⭐ Author

Akash M
