# LinkedIn post draft — technical build showcase

<!-- Angle: technical build showcase. Edit freely before posting. -->

I condensed my entire home compute fleet into a 10-inch rack.

Three nodes, one enclosure:
- **Dev workstation** — Ryzen 9 9950X, RTX 5080 + RTX 4070 Ti, MSI X670E ACE
- **AI inference server** — NVIDIA DGX Spark, GB10 Grace-Blackwell, 128GB unified memory
- **General server host** — Mac mini M4, running Vault, Postgres, and IB/TWS

Plus a MikroTik CRS310-8G+2S+ switch and a UniFi UX7 gateway, patched and cable-managed
inside the same 10" footprint.

The fun part: the X670E board doesn't fit a standard 10" rack shelf at full size. I pulled
it from its case and hand-cut an acrylic open-frame plate to mount it vertically — both
GPUs run off PCIe 5.0 riser cables to clear the rack depth.

The number that surprised me: I tracked what I originally paid against today's market
price for every part. Built for ~$11K — and thanks to the GPU/NAND/DRAM shortage running
through 2026, it would cost *more* to build today than it did when I built it. Every
component I reused from an older build (motherboard, CPU, both NVMe drives, RAM) is worth
more now than its original price.

Full parts list, pricing breakdown, and build notes: [repo link]

#homelab #selfhosted #AI #hardware
