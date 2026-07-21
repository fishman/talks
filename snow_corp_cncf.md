---
theme: kubecon_japan
title: HAMi - Shared GPU Scheduling & Proactive Autoscaling
logo: assets/brand/dynamia-logo.svg
logo_dark: assets/brand/dynamia-logo-white.png
watermark: assets/brand/kubecon_japan/cncf_logo.svg
footer: Shared GPU Scheduling & Proactive Autoscaling - KubeCon CloudNativeCon Japan 2026
paginate: true
---

@kicker HAMi - A CNCF Incubation Project

# Shared GPU Scheduling & Proactive Autoscaling

@subtitle A Production Blueprint for 1000+ GPUs

@speaker name="Jeonghyun Kim" role="AI Engineer, SNOW Corp."
@speaker name="Reza Jelveh" role="Solution Architect, Dynamia AI  -  Makers of HAMi" github=github.com/rezajelveh twitter=@rezajelveh

---

@layout image-right

## The Challenge at Scale

@subtitle 200M Users, 1000+ GPUs, 1200+ Workflows

SNOW Corp., subsidiary of NAVER, manages 1000+ A100 GPUs serving 200M users across three top-ranked GenAI applications  -  SNOW, EPIK, B612  -  handling extreme traffic volatility from viral AI trends.

- {icon:trophy cls=accent-primary} 3 apps in a16z Top 50 Gen AI Mobile Apps
- {icon:users cls=accent-primary} #1 Camera/Photo app in Korea, Japan, Vietnam
- {icon:download cls=accent-primary} 1.5B+ cumulative downloads

![a16z Top 50 Gen AI Mobile Apps](assets/snow/snow-top50.png)

---

## Talk Overview

**What you'll learn:**

- {icon:cpu cls=accent-primary} Integrating HAMi for vGPU virtualization
- {icon:trending-up cls=accent-primary} Extending KEDA with custom Consumer Saturation metric
- {icon:globe cls=accent-primary} Multi-region scaling via Helm GitOps

**Concrete results:** 55% GPU waste cut, 91% faster recovery during surges.

---

# PART 1  -  Introduction

@subtitle GPU Sharing, Scheduling & DRA

---
---

## What is HAMi

![Before HAMi](assets/hami_intro/before-hami.png)

---

## What is HAMi

![After HAMi](assets/hami_intro/after-hami.png)

---

## Device Plugin vs DRA

@layout compare

::: card {tag=compare}
### Device Plugin

- Pod requests `nvidia.com/gpu`
- Fixed allocation at pod creation
- No sharing between pods
- Vendor-specific APIs only
- No scheduling policies
:::

::: arrow

{icon:arrow-right cls=accent-primary size=48}
:::

::: card {tag=compare}
### Dynamic Resource Allocation

- Flexible resource claiming via structured params
- Vendor-neutral interface
- Dynamic allocation at runtime
- K8s 1.32 beta, 1.34 GA
- No GPU sharing built-in
:::

---

## HAMi Capabilities

::: grid {cols=2}
::: card
### {icon:layers cls=accent-primary} Heterogeneous Management

Manage and schedule GPU, NPU, MLU, and other accelerators in one workflow.
:::
::: card
### {icon:shield-check cls=accent-primary} Hard Isolation

Slice memory and compute precisely with hard isolation at runtime.
:::
::: card
### {icon:git-branch cls=accent-contrast} Advanced Scheduling

Use binpack, spread, and topology-aware policies for better placement.
:::
::: card
### {icon:box cls=accent-primary} Kubernetes Native

Work with Kubernetes APIs, DRA, and CDI for easier adoption.
:::
::: card
### {icon:gauge cls=accent-primary} Resource Isolation & QoS

Control memory and core quotas for fairer and more stable sharing.
:::
::: card
### {icon:chart-bar cls=accent-contrast} Unified Monitoring

Provide consistent metrics and visibility across device vendors.
:::
:::

---

## GPU Sharing

@subtitle Dynamic fine-grained device slicing

- **All NVIDIA series** supported
- **Fine-grained:** as small as 1MB device memory, 1% computing cores
- **Transparent to tasks** - no code changes required
- **Hard resource isolation** inside containers

HAMi provides device sharing by dynamic device slicing. A task allocates a portion of GPU, leaving the rest for other tasks.

---

## How GPU Sharing Works

HAMi-Core uses **symbolic hijacking** inside containers:

| Requirement | Specification |
|-------------|---------------|
| NVIDIA driver | >= 440 |
| CUDA | >= 10.2 |
| Device Memory isolation | Yes |
| Core utilization limit | Yes |
| Fault isolation | Yes |
| Transparent to GPU tasks | Yes |

---

## HAMi vs Other Projects

| Feature | HAMi | NVIDIA device-plugin | NVIDIA DRA driver |
|---------|:---:|:---:|:---:|
| Multi-vendor GPUs | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| GPU sharing | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} |
| Flexible scheduling | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Dynamic MIG | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Memory oversubscription | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Topology-aware | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |
| Heterogeneous devices | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} |

---

## HAMi + DRA: The Full Picture

| Capability | Device Plugin | DRA | HAMi | HAMi + DRA |
|------------|:---:|:---:|:---:|:---:|
| GPU sharing | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} |
| Vendor-neutral | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} |
| Structured params | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} |
| Dynamic allocation | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} |
| Zero code changes | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:check cls=accent-primary} |
| Binpack / Spread | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} |
| Topology-aware | {icon:x cls=accent-secondary} | {icon:x cls=accent-secondary} | {icon:check cls=accent-primary} | {icon:x cls=accent-secondary} |

> DRA (beta in K8s 1.32, GA in 1.34) adds vendor-neutral structured parameters and dynamic allocation. HAMi fills the gaps: GPU sharing, binpack/spread, topology-aware scheduling, and zero-code migration  -  all production-hardened.

---

## HAMi Architecture

- {icon:git-branch cls=accent-primary} **HAMi scheduler** extends kube-scheduler
- {icon:hard-drive cls=accent-secondary} **Device plugin** reports virtualized GPU capacity
- {icon:layers cls=accent-contrast} **vGPU abstraction** maps physical → virtual devices
- {icon:shield-check cls=accent-primary} **Transparent to workloads**  -  no code changes

Integrates with KEDA (autoscaling), Helm (deployment), Prometheus (monitoring)  -  all CNCF ecosystem.

---

@layout image-right

## GPU Sharing Architecture

![HAMi GPU Sharing](assets/dra/10000000000007D00000045C4E7A6399.png)

---

@layout image-right

## Scheduling Policies

@subtitle Binpack & Spread

![Binpack vs Spread scheduling](assets/hami_intro/binpack_spread.png)

- **Node Binpack:** packs tasks onto fewer nodes to reduce fragmentation and free entire machines
- **GPU Spread:** distributes workloads across available GPUs for maximum parallelism
- **When it matters:** mixed small/large workloads on shared clusters -- binpack consolidates, spread balances burst traffic

---

@layout image-right

## Scheduling Policies

@subtitle Topology-Aware

![NUMA topology-aware scheduling](assets/hami_intro/topology_numa.png)

- **NVLink:** 25 GB/s to 1800 GB/s inter-GPU bandwidth, ideal for multi-GPU training
- **PCIe:** 16 GB/s, bottleneck for cross-GPU communication
- **HAMi topology policy:** schedules multi-GPU workloads to NVLink-connected devices, avoids PCIe bridge pairs

---

## GPU Sharing Methods Compared

| Method | Multi-vendor | Isolation | Fragmentation | Overhead |
|--------|:---:|:---:|:---:|:---:|
| HAMi vGPU | {icon:check cls=accent-primary} | Strong | Low | Low |
| CUDA Streams | {icon:x cls=accent-secondary} | Weak | High | Low |
| MPS | {icon:x cls=accent-secondary} | Medium | Low | Medium |
| Time-slicing | {icon:x cls=accent-secondary} | Weak | High | Low |
| MIG | {icon:x cls=accent-secondary} | Strong | High | N/A |
| NVIDIA vGPU | {icon:x cls=accent-secondary} | Strong | Low | High |

---

# PART 2  -  Problem

@subtitle GPU underutilization, atomic allocation, multi-tenant contention

---

## The Problem

Kubernetes treats GPUs as atomic resources, forcing over-provisioning and low utilization in multi-tenant AI Notebooks. DRA and HAMi's vGPU virtualization solve this, but only if implemented correctly.

- GPUs are **allocated whole**: a 1GB inference task blocks an entire 80GB device
- **Over-provisioning** is the default: request peak, burn budget, idle silicon
- **DRA** (Dynamic Resource Allocation) enables structured GPU requests but doesn't solve sharing
- **HAMi** provides the fractional GPU layer DRA needs for fine-grained allocation

---

## Workload Challenges

::: grid {cols=2}
::: card {tag=red}
### {icon:triangle-alert cls=accent-secondary} System Instability

No centralized monitoring or recovery. Serving instability directly impacted 200M users.
:::
::: card {tag=yellow}
### {icon:chart-pie cls=accent-contrast} Inefficient Utilization

Static allocation caused GPU fragmentation. Resources wasted, performance unpredictable.
:::
:::

::: card {tag=cyan}
### {icon:hard-drive cls=accent-primary} Operational Overload

No automatic recovery. Manual intervention drove up staff workload and operational costs.
:::

---

@layout image-right

## The Legacy: Static Docker

![SNOW Legacy Docker Architecture](assets/snow/snow-legacy-docker.png)

- Manual GPU binding per host
- Local volume containers
- Isolated Docker hosts with no centralized control
- No sharing between GPUs  -  each pod consumed a full device

---

@layout compare
@variant dark

## Infrastructure Evolution

::: card {tag=compare}
### AS-IS: Legacy Docker


- Manual GPU binding
- Isolated hosts
- Static allocation
- Low utilization.
  :::

::: arrow

{icon:arrow-right cls=accent-primary size=48}
:::

::: card {tag=compare}
### TO-BE: Kubernetes + HAMi

- Centralized control plane
- Dynamic node pools
- vGPU sharing enabled
- Automated recovery + scaling
![Legacy Docker](assets/snow/snow-kubernetes-gpu-cluster.png)
:::

---

## GPU Sharing: The Migration Hurdle

Kubernetes' strict GPU isolation blocked the sequential "Train-to-Inference" pipeline.

![Sequential Train-to-Inference Pipeline](assets/snow/sequential-train-to-inference.png)

**Problem:** Default scheduler cannot share one GPU across containers.

**Without HAMi:** 2x GPU usage or massive code rewrite.

---

# PART 3  -  Methodology

@subtitle How We Fixed It

---

@layout image-right

## Building a Cloud-Native Foundation

| Project | Role |
|---------|------|
| Kubernetes | Container orchestration |
| Cilium | High-performance CNI |
| HAMi | GPU sharing scheduler |
| KEDA | Autoscaling |
| Helm | Service configuration |
| Prometheus + Grafana | Monitoring |
| Traefik | Ingress / reverse proxy |

Multi-region on-premise HA clusters with decoupled ETCD topology for production survivability.

@col

![HA Kubernetes Cluster Architecture](assets/snow/HA-kubernetes-cluster-architecture.png)

---

@layout image-right

## Helm-Based Service Deployment

![Service Deployment Workflow](assets/snow/service-deployment-workflow.png)

Standardized deployment via Helm Charts. Sync between charts and clusters performed by CI/CD pipeline (GitHub Actions).

---

@layout image-right

## Migration Solution: HAMi vGPU

![HAMi GPU Allocation Feature](assets/snow/hami-gpu-allocation-feature.png)

- **Device sharing:** Multiple containers share one GPU concurrently
- **Zero code changes:** Install via Helm, assign GPUs in chart
- **Kubernetes-native:** Parallel with kube-scheduler, no conflicts

Result: flexible GPU scheduling comparable to Docker, with enhanced utilization and stability.

---

## Proactive GPU Orchestration

Traditional metrics (CPU/RAM/DCGM) fail to reflect GPU service saturation. Heterogeneous workloads mean utilization ≠ saturation.

**Solution: Custom KEDA Metric Server**
- Lightweight adapter exposes RabbitMQ consumer states to HPA
- "Consumer Saturation" metric: Unacked Messages / Active Consumers
- Proactive threshold provisions GPUs before saturation
- Absorbs 60-second model warm-up latency

---

# PART 4  -  Results

@subtitle What We Achieved

---

## Quantitative Results

| Metric | Improvement |
|--------|-------------|
| MTTR | -91% (~2hr → ~10min) |
| GPU surge errors | -85% during peak |
| Avg GPU time | -55% |
| Batch process time | -81% (~6hr → <1hr) |
| Cost savings | 10.8 man-months |
| Release cycle | 1-2 months → days |
| Peak traffic | 700% spike, zero downtime |

---

@layout image-right

## Error Reduction: Before vs After

![KEDA Error Count GPU Surges](assets/snow/keda-error-count-gpu-surges.png)

GPU surge-related user errors dropped 85% after KEDA-based GPU orchestration deployed (May 2025).

---

@variant dark
@layout image-left

## Hybrid Cloud Bursting: 700% Spike

![Real-world Validation](assets/snow/snow_kubecon.drawio_ghibli.png)

During the viral "Ghibli Filter" trend:
- Traffic tripled in 3 hours on a low-staff Saturday
- Autoscaling initially held, then GPU saturation hit
- Expanded from on-prem to CSP clusters via GitOps
- Unified Helm charts deployed across all regions

Achieved 7x peak consumption without service interruption.

---

@layout image-right

## GPU Monitoring Dashboard

![GPU Monitoring Dashboard](assets/snow/gpu-monitoring-dashboard.png)

Full visibility into GPU utilization, scheduling, and autoscaling across the entire fleet.

---

## Key Takeaways

::: grid {cols=3}
::: card {tag=green}
### {icon:shield-check cls=accent-primary} Production Blueprint

CNCF ecosystem provides production-grade foundation for AI workloads at scale. HAMi + KEDA = proven at 200M users.
:::
::: card {tag=cyan}
### {icon:cpu cls=accent-contrast} GPU Sharing

HAMi enables efficient GPU utilization without code changes  -  critical for migration from legacy Docker setups.
:::
::: card {tag=yellow}
### {icon:chart-bar cls=accent-contrast} Proactive Scaling

Custom KEDA metrics beat reactive scaling for GPU workloads with warm-up latency. Consumer Saturation is the key metric.
:::
:::

---

@kicker Questions

# Thank You

@speaker name="Jeonghyun Kim" role="AI Engineer, SNOW Corp."
@speaker name="Reza Jelveh" role="Solution Architect, Dynamia AI  -  Makers of HAMi" github=github.com/rezajelveh twitter=@rezajelveh
