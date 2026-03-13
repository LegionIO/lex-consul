# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Session
          include Legion::Extensions::Consul::Helpers::Client

          def create_session(node: nil, name: nil, lock_delay: nil, ttl: nil, behavior: nil, checks: nil, dc: nil, **)
            body = {}
            body[:Node] = node if node
            body[:Name] = name if name
            body[:LockDelay] = lock_delay if lock_delay
            body[:TTL] = ttl if ttl
            body[:Behavior] = behavior if behavior
            body[:Checks] = checks if checks
            params = {}
            params[:dc] = dc if dc
            response = connection(**).put('/v1/session/create', body) do |req|
              req.params = params
            end
            { result: response.body }
          end

          def destroy_session(id:, dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).put("/v1/session/destroy/#{id}", nil, params)
            { result: response.body }
          end

          def session_info(id:, dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).get("/v1/session/info/#{id}", params)
            { result: response.body }
          end

          def list_sessions(dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).get('/v1/session/list', params)
            { result: response.body }
          end

          def node_sessions(node:, dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).get("/v1/session/node/#{node}", params)
            { result: response.body }
          end

          def renew_session(id:, dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).put("/v1/session/renew/#{id}", nil, params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
