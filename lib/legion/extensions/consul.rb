# frozen_string_literal: true

require 'legion/extensions/consul/version'
require 'legion/extensions/consul/helpers/client'
require 'legion/extensions/consul/runners/kv'
require 'legion/extensions/consul/runners/agent'
require 'legion/extensions/consul/runners/catalog'
require 'legion/extensions/consul/runners/health'
require 'legion/extensions/consul/runners/session'
require 'legion/extensions/consul/runners/event'
require 'legion/extensions/consul/runners/status'
require 'legion/extensions/consul/client'

module Legion
  module Extensions
    module Consul
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
