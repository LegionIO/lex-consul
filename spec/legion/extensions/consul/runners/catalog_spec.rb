# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Catalog do
  let(:client) { Legion::Extensions::Consul::Client.new(url: 'http://consul.test:8500', token: 'test-token') }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:test_connection) do
    Faraday.new(url: 'http://consul.test:8500') do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter :test, stubs
    end
  end

  before { allow(client).to receive(:connection).and_return(test_connection) }

  describe '#datacenters' do
    it 'returns available datacenters' do
      stubs.get('/v1/catalog/datacenters') do
        [200, { 'Content-Type' => 'application/json' }, %w[dc1 dc2]]
      end
      result = client.datacenters
      expect(result[:result]).to eq(%w[dc1 dc2])
    end
  end

  describe '#nodes' do
    it 'returns catalog nodes' do
      stubs.get('/v1/catalog/nodes') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'Node' => 'node1', 'Address' => '10.1.1.1' }]]
      end
      result = client.nodes
      expect(result[:result].first['Node']).to eq('node1')
    end
  end

  describe '#services' do
    it 'returns catalog services' do
      stubs.get('/v1/catalog/services') do
        [200, { 'Content-Type' => 'application/json' }, { 'consul' => [], 'web' => %w[v1 v2] }]
      end
      result = client.services
      expect(result[:result]).to have_key('web')
    end
  end

  describe '#service' do
    it 'returns nodes for a service' do
      stubs.get('/v1/catalog/service/web') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'Node' => 'node1', 'ServiceName' => 'web' }]]
      end
      result = client.service(service: 'web')
      expect(result[:result].first['ServiceName']).to eq('web')
    end
  end

  describe '#register' do
    it 'registers a node' do
      stubs.put('/v1/catalog/register') { [200, { 'Content-Type' => 'application/json' }, true] }
      result = client.register(node: 'new-node', address: '10.1.1.5')
      expect(result[:result]).to be true
    end
  end

  describe '#deregister' do
    it 'deregisters a node' do
      stubs.put('/v1/catalog/deregister') { [200, { 'Content-Type' => 'application/json' }, true] }
      result = client.deregister(node: 'old-node')
      expect(result[:result]).to be true
    end
  end
end
