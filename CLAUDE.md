# lex-consul: HashiCorp Consul Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent (Level 2)**: `/Users/miverso2/rubymine/legion/extensions/CLAUDE.md`
- **Parent (Level 1)**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Legion Extension that connects LegionIO to HashiCorp Consul. Provides runners for interacting with the Consul HTTP API covering KV store, agent management, service catalog, health checks, sessions, events, and cluster status.

**GitHub**: https://github.com/LegionIO/lex-consul
**License**: MIT
**Version**: 0.1.2

## Architecture

```
Legion::Extensions::Consul
├── Runners/
│   ├── Kv                # KV store CRUD (get, put, delete, list keys)
│   ├── Agent             # Agent info, members, join/leave, maintenance
│   ├── Catalog           # Datacenters, nodes, services, register/deregister
│   ├── Health            # Node health, service checks, checks by state
│   ├── Session           # Distributed lock sessions (create, destroy, renew)
│   ├── Event             # Custom event fire and list
│   ├── Status            # Raft leader and peers
│   └── Partitions        # Admin Partitions CRUD (Enterprise)
├── Helpers/
│   └── Client            # Faraday connection builder (Consul HTTP API v1)
└── Client                # Standalone client class (includes all runners)
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday` | HTTP client for Consul HTTP API |

## API Coverage

| Consul API | Runner | Methods |
|------------|--------|---------|
| `/v1/kv/` | Kv | get_key, put_key, delete_key, list_keys |
| `/v1/agent/` | Agent | self_info, members, join, leave, force_leave, reload, maintenance |
| `/v1/catalog/` | Catalog | datacenters, nodes, services, service, node, register, deregister |
| `/v1/health/` | Health | node_health, service_checks, service_health, checks_in_state, connect_health |
| `/v1/session/` | Session | create_session, destroy_session, session_info, list_sessions, node_sessions, renew_session |
| `/v1/event/` | Event | fire_event, list_events |
| `/v1/status/` | Status | leader, peers |
| `/v1/partitions` | Partitions | list_partitions, get_partition, create_partition, delete_partition (Enterprise) |

## Testing

30 specs across 10 spec files.

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

**Maintained By**: Matthew Iverson (@Esity)
