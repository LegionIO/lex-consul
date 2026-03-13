# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'
require 'legion/extensions/consul/runners/kv'
require 'legion/extensions/consul/runners/agent'
require 'legion/extensions/consul/runners/catalog'
require 'legion/extensions/consul/runners/health'
require 'legion/extensions/consul/runners/session'
require 'legion/extensions/consul/runners/event'
require 'legion/extensions/consul/runners/status'

module Legion
  module Extensions
    module Consul
      class Client
        include Helpers::Client
        include Runners::Kv
        include Runners::Agent
        include Runners::Catalog
        include Runners::Health
        include Runners::Session
        include Runners::Event
        include Runners::Status

        attr_reader :opts

        def initialize(url: 'http://127.0.0.1:8500', token: nil, **extra)
          @opts = { url: url, token: token, **extra }
        end

        def connection(**override)
          super(**@opts.merge(override))
        end
      end
    end
  end
end
