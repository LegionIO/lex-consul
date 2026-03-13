# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module Consul
      module Helpers
        module Client
          def connection(url: 'http://127.0.0.1:8500', token: nil, **_opts)
            Faraday.new(url: url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              conn.headers['X-Consul-Token'] = token if token
            end
          end
        end
      end
    end
  end
end
