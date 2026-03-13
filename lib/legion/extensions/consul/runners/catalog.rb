# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Catalog
          include Legion::Extensions::Consul::Helpers::Client

          def datacenters(**)
            response = connection(**).get('/v1/catalog/datacenters')
            { result: response.body }
          end

          def nodes(dc: nil, near: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:near] = near if near
            params[:filter] = filter if filter
            response = connection(**).get('/v1/catalog/nodes', params)
            { result: response.body }
          end

          def services(dc: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:filter] = filter if filter
            response = connection(**).get('/v1/catalog/services', params)
            { result: response.body }
          end

          def service(service:, dc: nil, tag: nil, near: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:tag] = tag if tag
            params[:near] = near if near
            params[:filter] = filter if filter
            response = connection(**).get("/v1/catalog/service/#{service}", params)
            { result: response.body }
          end

          def node(node:, dc: nil, filter: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:filter] = filter if filter
            response = connection(**).get("/v1/catalog/node/#{node}", params)
            { result: response.body }
          end

          def register(node:, address:, service: nil, check: nil, dc: nil, **)
            body = { Node: node, Address: address }
            body[:Service] = service if service
            body[:Check] = check if check
            body[:Datacenter] = dc if dc
            response = connection(**).put('/v1/catalog/register', body)
            { result: response.body }
          end

          def deregister(node:, check_id: nil, service_id: nil, dc: nil, **)
            body = { Node: node }
            body[:CheckID] = check_id if check_id
            body[:ServiceID] = service_id if service_id
            body[:Datacenter] = dc if dc
            response = connection(**).put('/v1/catalog/deregister', body)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
