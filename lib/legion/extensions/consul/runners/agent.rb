# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Agent
          include Legion::Extensions::Consul::Helpers::Client

          def self_info(**)
            response = connection(**).get('/v1/agent/self')
            { result: response.body }
          end

          def members(wan: false, **)
            params = {}
            params[:wan] = true if wan
            response = connection(**).get('/v1/agent/members', params)
            { result: response.body }
          end

          def join(address:, wan: false, **)
            params = {}
            params[:wan] = true if wan
            response = connection(**).put("/v1/agent/join/#{address}", nil, params)
            { result: response.body }
          end

          def leave(**)
            response = connection(**).put('/v1/agent/leave')
            { result: response.body }
          end

          def force_leave(node:, prune: false, **)
            params = {}
            params[:prune] = true if prune
            response = connection(**).put("/v1/agent/force-leave/#{node}", nil, params)
            { result: response.body }
          end

          def reload(**)
            response = connection(**).put('/v1/agent/reload')
            { result: response.body }
          end

          def maintenance(enable:, reason: nil, **)
            params = { enable: enable }
            params[:reason] = reason if reason
            response = connection(**).put('/v1/agent/maintenance', nil, params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
