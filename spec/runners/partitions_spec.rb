# frozen_string_literal: true

require 'spec_helper'
require 'legion/extensions/consul/runners/partitions'

RSpec.describe Legion::Extensions::Consul::Runners::Partitions do
  let(:client) { Legion::Extensions::Consul::Client.new(url: 'http://consul.test:8500', token: 'test-token') }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_conn) do
    Faraday.new do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before do
    allow(client).to receive(:connection).and_return(test_conn)
  end

  describe '#list_partitions' do
    it 'returns list of partitions' do
      body = '[{"Name":"default","Description":"Default"},{"Name":"mypart","Description":"Custom"}]'
      stubs.get('/v1/partitions') { [200, { 'Content-Type' => 'application/json' }, body] }
      result = client.list_partitions
      expect(result[:result]).to be_an(Array)
      expect(result[:result].size).to eq(2)
    end
  end

  describe '#get_partition' do
    it 'returns partition details' do
      stubs.get('/v1/partition/mypart') do
        [200, { 'Content-Type' => 'application/json' }, '{"Name":"mypart","Description":"Custom"}']
      end
      result = client.get_partition(name: 'mypart')
      expect(result[:result]['Name']).to eq('mypart')
    end
  end

  describe '#create_partition' do
    it 'creates a partition and returns the result' do
      stubs.put('/v1/partition/new-part') do
        [200, { 'Content-Type' => 'application/json' }, '{"Name":"new-part","Description":""}']
      end
      result = client.create_partition(name: 'new-part')
      expect(result[:result]['Name']).to eq('new-part')
    end

    it 'accepts an optional description' do
      stubs.put('/v1/partition/new-part') do
        [200, { 'Content-Type' => 'application/json' }, '{"Name":"new-part","Description":"Test"}']
      end
      result = client.create_partition(name: 'new-part', description: 'Test')
      expect(result[:result]['Description']).to eq('Test')
    end
  end

  describe '#delete_partition' do
    it 'deletes a partition and returns success' do
      stubs.delete('/v1/partition/old-part') { [200, { 'Content-Type' => 'application/json' }, '{}'] }
      result = client.delete_partition(name: 'old-part')
      expect(result[:result]).to be_truthy
    end
  end
end
