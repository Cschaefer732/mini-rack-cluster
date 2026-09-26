---
type: entity
updated: 2026-09-26
sources: [personal-pc-config/network, amazon-order-screenshots]
---

# Network Gear

Two devices, physically in the [[rack-enclosure]], carrying traffic for the
[[fleet-nodes]] plus macbook-pro (external to the rack).

## MikroTik CRS310-8G+2S+ (switch)

Port map: ether2 → spark-a81e, ether3 → uplink to UX7, ether7 → macbook-pro,
ether8 → nova-linux. Full config lives in the private `personal-pc-config`
repo — only the abstracted port map is public (`configs/README.md`); the raw
RouterOS export carries the device serial, hardware MAC, and internal LAN
topology, none of which belong in a public repo. Paid $208.80; current market
$208.80.

## UniFi UX7 (gateway/router, model UDMA69B)

DHCP reservations pinned per-device; no WAN-facing admin access. Paid $234;
current market $199 (Ubiquiti store, flat).

Cabling: Tecmojo 12-port Cat6 patch panel, GeeekPi horizontal cable manager,
Tecmojo brush cable-entry panel, Cat6a patch cables.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
- [[pricing]]
