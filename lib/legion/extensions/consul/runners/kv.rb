# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Kv
          include Legion::Extensions::Consul::Helpers::Client

          def get_key(key:, dc: nil, recurse: false, raw: false, **)
            params = {}
            params[:dc] = dc if dc
            params[:recurse] = true if recurse
            params[:raw] = true if raw
            response = connection(**).get("/v1/kv/#{key}", params)
            { result: response.body }
          end

          def put_key(key:, value:, dc: nil, flags: nil, cas: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:flags] = flags if flags
            params[:cas] = cas if cas
            response = connection(**).put("/v1/kv/#{key}", value) do |req|
              req.params = params
              req.headers['Content-Type'] = 'text/plain'
            end
            { result: response.body }
          end

          def delete_key(key:, dc: nil, recurse: false, cas: nil, **)
            params = {}
            params[:dc] = dc if dc
            params[:recurse] = true if recurse
            params[:cas] = cas if cas
            response = connection(**).delete("/v1/kv/#{key}", params)
            { result: response.body }
          end

          def list_keys(prefix: '', dc: nil, separator: nil, **)
            params = { keys: true }
            params[:dc] = dc if dc
            params[:separator] = separator if separator
            response = connection(**).get("/v1/kv/#{prefix}", params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
