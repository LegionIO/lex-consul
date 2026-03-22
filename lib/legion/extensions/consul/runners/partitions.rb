# frozen_string_literal: true

require 'legion/extensions/consul/helpers/client'

module Legion
  module Extensions
    module Consul
      module Runners
        module Partitions
          include Legion::Extensions::Consul::Helpers::Client

          def list_partitions(**)
            response = connection(**).get('/v1/partitions')
            { result: response.body }
          end

          def get_partition(name:, **)
            response = connection(**).get("/v1/partition/#{name}")
            { result: response.body }
          end

          def create_partition(name:, description: nil, **)
            body = { Name: name }
            body[:Description] = description if description
            response = connection(**).put("/v1/partition/#{name}", body)
            { result: response.body }
          end

          def delete_partition(name:, **)
            response = connection(**).delete("/v1/partition/#{name}")
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
