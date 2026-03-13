# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Health
          include Legion::Extensions::Consul::Helpers::Client

          def node_health(node:, dc: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:filter] = filter if filter
            response = connection(**).get("/v1/health/node/#{node}", params)
            { result: response.body }
          end

          def service_checks(service:, dc: nil, near: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:near] = near if near
            params[:filter] = filter if filter
            response = connection(**).get("/v1/health/checks/#{service}", params)
            { result: response.body }
          end

          def service_health(service:, dc: nil, passing: false, tag: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:passing] = true if passing
            params[:tag] = tag if tag
            params[:filter] = filter if filter
            response = connection(**).get("/v1/health/service/#{service}", params)
            { result: response.body }
          end

          def checks_in_state(state:, dc: nil, near: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:near] = near if near
            params[:filter] = filter if filter
            response = connection(**).get("/v1/health/state/#{state}", params)
            { result: response.body }
          end

          def connect_health(service:, dc: nil, passing: false, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:passing] = true if passing
            params[:filter] = filter if filter
            response = connection(**).get("/v1/health/connect/#{service}", params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
