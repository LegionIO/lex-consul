# lex-consul

HashiCorp Consul integration for [LegionIO](https://github.com/LegionIO/LegionIO). Provides runners for interacting with the Consul HTTP API covering KV store, agent management, catalog, health checks, sessions, events, and cluster status.

## Installation

```bash
gem install lex-consul
```

## Functions

### KV Store (`Runners::Kv`)
- `get_key` - Read a key (supports recursive and raw modes)
- `put_key` - Write a key (supports CAS, flags, lock acquire/release)
- `delete_key` - Delete a key (supports recursive delete and CAS)
- `list_keys` - List keys by prefix

### Agent (`Runners::Agent`)
- `self_info` - Read agent configuration
- `members` - List cluster members
- `join` - Join a node to the cluster
- `leave` - Graceful leave
- `force_leave` - Force remove a node
- `reload` - Reload agent configuration
- `maintenance` - Enable/disable maintenance mode

### Catalog (`Runners::Catalog`)
- `datacenters` - List known datacenters
- `nodes` - List catalog nodes
- `services` - List catalog services
- `service` - List nodes for a service
- `node` - Get services on a node
- `register` - Register a node/service/check
- `deregister` - Deregister a node/service/check

### Health (`Runners::Health`)
- `node_health` - Health checks for a node
- `service_checks` - Checks for a service
- `service_health` - Healthy service instances
- `checks_in_state` - Checks by state (passing/warning/critical)
- `connect_health` - Mesh-capable service instances

### Session (`Runners::Session`)
- `create_session` - Create a session (for distributed locks)
- `destroy_session` - Destroy a session
- `session_info` - Read session details
- `list_sessions` - List all sessions
- `node_sessions` - List sessions for a node
- `renew_session` - Renew a session TTL

### Event (`Runners::Event`)
- `fire_event` - Fire a custom event
- `list_events` - List recent events

### Status (`Runners::Status`)
- `leader` - Get Raft leader address
- `peers` - List Raft peer addresses

## Standalone Usage

```ruby
require 'legion/extensions/consul'

client = Legion::Extensions::Consul::Client.new(
  url: 'http://consul.example.com:8500',
  token: 'my-consul-token'
)

# KV operations
client.put_key(key: 'config/db/host', value: 'db.example.com')
client.get_key(key: 'config/db/host')
client.list_keys(prefix: 'config/')

# Service discovery
client.services
client.service_health(service: 'web', passing: true)

# Cluster status
client.leader
client.members
```

## Requirements

- Ruby >= 3.4
- [LegionIO](https://github.com/LegionIO/LegionIO) framework (for framework mode)
- HashiCorp Consul cluster (any version with HTTP API v1)

## License

MIT
