---
type: entity
updated: 2026-09-26
sources: [personal-pc-config/wiki/entities, user-interview]
---

# Fleet Nodes

Three compute nodes physically consolidated into the [[rack-enclosure]]. Each
keeps its pre-existing fleet role — see `personal-pc-config` (private repo)
for full per-machine config and history.

## nova-linux — dev workstation + GPU compute

MSI MEG X670E ACE, Ryzen 9 9950X, RTX 5080 (primary) + RTX 4070 Ti (CUDA),
32GB DDR5-4800 single-channel (Crucial CT32G48C40U5), WD_BLACK SN850X 4TB +
SN770 2TB NVMe. Ubuntu 24.04.

The X670E ACE (EATX) doesn't fit a standard 10" shelf at full size — pulled
from its original case, mounted vertically on a hand-cut acrylic open-frame
plate. Both GPUs run off PCIe 5.0 riser cables to clear rack depth.

## machub — general server host

Mac mini M4, base config (16GB/256GB). Runs HashiCorp Vault, Postgres,
IB Gateway/TWS, plus game/desktop streaming (Parsec, Steam). Never sleeps.

## spark-a81e — AI inference node

NVIDIA DGX Spark, GB10 Grace-Blackwell superchip, 128GB unified LPDDR5X
memory (coherent CPU/GPU, no separate VRAM pool). Runs ollama (`:11434`) as
the fleet's model endpoint, plus the sea-wiki MCP and the ArchmediesSea agent
loop.

## See Also

- [[rack-enclosure]]
- [[network-gear]]
- [[pricing]]
