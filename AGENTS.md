# mini-rack-cluster

A 10-inch mini rack consolidating a 3-node home fleet (dev workstation, AI
inference server, general server host) plus network gear into one enclosure.

## Architecture

This is a hardware documentation project, not a software system. Each node
(nova-linux, machub, spark-a81e) keeps its existing role and config, tracked
in the separate `personal-pc-config` repo. This repo documents the physical
consolidation: parts, pricing, build notes, and the network device configs
specific to the rack.

## Conventions

- Conventional commits: `feat:` `fix:` `chore:` `docs:` `refactor:` `test:` `ci:`
- Comments explain *why*, not what
- No abstractions for single-use code
- No speculative features — `scripts/` stays empty until a real need exists

## Wiki

Project knowledge lives in `wiki/` — also an Obsidian vault (open `wiki/` as vault in Obsidian).
- `ingest [source]` — add a source, update wiki pages
- `query [question]` — ask a question, answer gets filed
- `lint` — find contradictions, stale claims, orphan pages
