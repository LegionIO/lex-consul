# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Agent do
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

  describe '#self_info' do
    it 'returns agent configuration' do
      stubs.get('/v1/agent/self') do
        [200, { 'Content-Type' => 'application/json' }, { 'Config' => { 'Datacenter' => 'dc1' } }]
      end
      result = client.self_info
      expect(result[:result]['Config']['Datacenter']).to eq('dc1')
    end
  end

  describe '#members' do
    it 'returns cluster members' do
      stubs.get('/v1/agent/members') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'Name' => 'node1', 'Status' => 1 }]]
      end
      result = client.members
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['Name']).to eq('node1')
    end
  end

  describe '#reload' do
    it 'reloads agent configuration' do
      stubs.put('/v1/agent/reload') { [200, { 'Content-Type' => 'application/json' }, nil] }
      result = client.reload
      expect(result).to have_key(:result)
    end
  end

  describe '#maintenance' do
    it 'enables maintenance mode' do
      stubs.put('/v1/agent/maintenance') { [200, { 'Content-Type' => 'application/json' }, nil] }
      result = client.maintenance(enable: true, reason: 'scheduled update')
      expect(result).to have_key(:result)
    end
  end
end
