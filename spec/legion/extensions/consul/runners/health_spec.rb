# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Health do
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

  describe '#node_health' do
    it 'returns health checks for a node' do
      stubs.get('/v1/health/node/node1') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'CheckID' => 'serfHealth', 'Status' => 'passing' }]]
      end
      result = client.node_health(node: 'node1')
      expect(result[:result].first['Status']).to eq('passing')
    end
  end

  describe '#service_checks' do
    it 'returns checks for a service' do
      stubs.get('/v1/health/checks/web') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'ServiceName' => 'web', 'Status' => 'passing' }]]
      end
      result = client.service_checks(service: 'web')
      expect(result[:result].first['ServiceName']).to eq('web')
    end
  end

  describe '#service_health' do
    it 'returns healthy service instances' do
      stubs.get('/v1/health/service/web') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'Service' => { 'Service' => 'web' } }]]
      end
      result = client.service_health(service: 'web')
      expect(result[:result].first['Service']['Service']).to eq('web')
    end
  end

  describe '#checks_in_state' do
    it 'returns checks in critical state' do
      stubs.get('/v1/health/state/critical') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'CheckID' => 'web-check', 'Status' => 'critical' }]]
      end
      result = client.checks_in_state(state: 'critical')
      expect(result[:result].first['Status']).to eq('critical')
    end
  end
end
