# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Event
          include Legion::Extensions::Consul::Helpers::Client

          def fire_event(name:, body: nil, dc: nil, node: nil, service: nil, tag: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:node] = node if node
            params[:service] = service if service
            params[:tag] = tag if tag
            response = connection(**).put("/v1/event/fire/#{name}", body) do |req|
              req.params = params
              req.headers['Content-Type'] = 'text/plain' if body
            end
            { result: response.body }
          end

          def list_events(name: nil, node: nil, service: nil, tag: nil, **)
            params = {}
            params[:name] = name if name
            params[:node] = node if node
            params[:service] = service if service
            params[:tag] = tag if tag
            response = connection(**).get('/v1/event/list', params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
