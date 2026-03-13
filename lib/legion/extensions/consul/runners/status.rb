# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Status
          include Legion::Extensions::Consul::Helpers::Client

          def leader(dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).get('/v1/status/leader', params)
            { result: response.body }
          end

          def peers(dc: nil, **)
            params = {}
            params[:dc] = dc if dc
            response = connection(**).get('/v1/status/peers', params)
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
