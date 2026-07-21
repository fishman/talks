---
theme: kcd_vietnam
title: HAMi Introduction
footer: HAMi - Heterogeneous AI Computing Virtualization Middleware
paginate: true
---

@variant dark
@kicker A CNCF Incubation Project

# HAMi

@subtitle Heterogeneous AI Computing Virtualization Middleware<br>Unified Management, Efficient Scheduling, Maximizing GPU Utilization


---

## GPU Utilization Impact

HAMi enables elastic GPU memory scaling -- idle tasks swap to host RAM, freeing device memory for active workloads:

```seaborn
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch

fig, ax = plt.subplots(figsize=(8, 2.8))

fg = plt.rcParams["text.color"]
dimmed = plt.rcParams["xtick.color"]
cmap = plt.get_cmap("Paired")
danger = cmap(4.5 / 12)
danger_bright = cmap(5 / 12)
elastic = cmap(2.5 / 12)
base = cmap(0.5 / 12)
ax.set_facecolor("none")
fig.patch.set_alpha(0)

r = 0.14
bs = f"round,pad={r}"

# Row 1: base=8, spike=3
ax.barh(1, 8, color=base, height=0.65)
ax.barh(1, 3, left=8, color=danger, height=0.65)
ax.plot([10, 10], [0.62, 1.38], color=danger, linewidth=2.5, solid_capstyle="butt")

# Row 2: base=8, spike=7
ax.barh(0, 8, color=base, height=0.65)
ax.barh(0, 7, left=8, color=elastic, height=0.65)
ax.plot([10, 10], [-0.38, 0.38], color=fg, linewidth=1.5, linestyle="--")
ax.plot([15, 15], [-0.38, 0.38], color=fg, linewidth=1.5, linestyle="--")

ax.set_xlim(0, 15.2)
ax.spines[["top", "right", "left", "bottom"]].set_visible(False)
ax.tick_params(left=False, bottom=False, labelleft=False, labelbottom=False)

ax.text(0, 1.38, "Without HAMi", ha="left", va="bottom", fontsize=10, color=fg, fontweight="bold")
ax.text(0, 0.38, "With HAMi: Elastic Scaling", ha="left", va="bottom", fontsize=10, color=fg, fontweight="bold")

ax.text(4, 1, "Normal base load", ha="center", va="center", fontsize=9, color=fg, fontweight="bold")
ax.text(9.5, 1, "Traffic spike", ha="center", va="center", fontsize=7.5, color=dimmed, fontweight="bold")
ax.text(10, 1.42, "10 GB limit", ha="center", va="bottom", fontsize=8, color=danger_bright, fontweight="bold")

ax.text(4, 0, "Normal base load", ha="center", va="center", fontsize=9, color=fg, fontweight="bold")
ax.text(11.5, 0, "Traffic spike", ha="center", va="center", fontsize=7.5, color=dimmed, fontweight="bold")
ax.text(10, -0.42, "10 GB\nsoft limit", ha="center", va="top", fontsize=7.5, color=dimmed)
ax.text(15, -0.42, "15 GB\nburst", ha="center", va="top", fontsize=7.5, color=dimmed)
```
---

## Priority Preemption

High-priority tasks preempt low-priority ones at CUDA kernel boundaries -- no wasted compute, clean context switch:

```seaborn
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(8, 2.8))

fg = plt.rcParams["text.color"]
dimmed = plt.rcParams["xtick.color"]
cmap = plt.get_cmap("Paired")
green = cmap(2.5 / 12)
blue = cmap(0.5 / 12)
red = cmap(4.5 / 12)
grey = "#9ca3af"
sleep_bg = "#374151"

ax.set_facecolor("none")
fig.patch.set_alpha(0)

# Top: IDLE(25) + EXECUTING(50) + IDLE(25)
ax.barh(1, 25, color=grey, height=0.65)
ax.barh(1, 50, left=25, color=green, height=0.65)
ax.barh(1, 25, left=75, color=grey, height=0.65)

# Bottom: EXECUTING(25) + SLEEP(50) + EXECUTING(25)
ax.barh(0, 25, color=blue, height=0.65)
ax.barh(0, 50, left=25, color=sleep_bg, height=0.65)
ax.barh(0, 25, left=75, color=blue, height=0.65)

# Segment dividers
for x in [25, 75]:
    ax.plot([x, x], [0.62, 1.38], color=fg, linewidth=0.8, linestyle="--")
    ax.plot([x, x], [-0.38, 0.62], color=fg, linewidth=0.8, linestyle="--")

ax.set_xlim(0, 100)
ax.spines[["top", "right", "left", "bottom"]].set_visible(False)
ax.tick_params(left=False, bottom=False, labelleft=False, labelbottom=False)

# Side labels
ax.text(-3, 1, "HIGH PRIORITY", ha="right", va="center", fontsize=10, color=green, fontweight="bold")
ax.text(-3, 0, "LOW PRIORITY", ha="right", va="center", fontsize=10, color=blue, fontweight="bold")

# Top bar labels
ax.text(12.5, 1, "IDLE", ha="center", va="center", fontsize=9, color=fg)
ax.text(50, 1, "EXECUTING", ha="center", va="center", fontsize=9, color=fg, fontweight="bold")
ax.text(87.5, 1, "IDLE", ha="center", va="center", fontsize=9, color=fg)

# Bottom bar labels
ax.text(12.5, 0, "EXECUTING", ha="center", va="center", fontsize=9, color=fg)
ax.text(50, 0, "SLEEP", ha="center", va="center", fontsize=9, color=red, fontweight="bold")
ax.text(87.5, 0, "EXECUTING", ha="center", va="center", fontsize=9, color=fg)

ax.text(50, -0.35, "CUDA-KERNEL BOUNDARY", ha="center", va="top", fontsize=7, color=red)
```
