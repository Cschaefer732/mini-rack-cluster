# Network configs

Configs for the two network devices physically in this rack. Full history,
troubleshooting notes, and the raw RouterOS export live in the fleet-wide
`personal-pc-config` repo (private) — this is a public repo, so only an
abstracted summary lives here. RouterOS exports don't carry passwords, but
they do carry the device serial number, hardware MAC, license/software ID,
and internal LAN topology, which have no reason to be public.

## MikroTik CRS310-8G+2S+ (switch)

Port map:

| port | device |
|---|---|
| ether2 | spark-a81e (DGX Spark) |
| ether3 | uplink to UX7 gateway |
| ether7 | macbook-pro (external to the rack) |
| ether8 | nova-linux |

## UX7 gateway (UniFi Express 7, UDMA69B)

Not exported here — UniFi OS config lives behind SSO + 2FA with no local export
file. Key applied settings, for reference:

- DHCP reservations pinned for spark, nova-linux, macbook-pro, and machub
- DHCP pool trimmed to avoid conflicting with the MikroTik's static management IP
- No WAN-facing admin access (UniFi default-deny, untouched)

Credentials and full detail: `personal-pc-config/network/ux7/README.md` (private repo).
