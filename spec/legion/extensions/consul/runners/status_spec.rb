# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Status do
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

  describe '#leader' do
    it 'returns the Raft leader' do
      stubs.get('/v1/status/leader') do
        [200, { 'Content-Type' => 'application/json' }, '"10.1.10.12:8300"']
      end
      result = client.leader
      expect(result[:result]).to eq('10.1.10.12:8300')
    end
  end

  describe '#peers' do
    it 'returns Raft peers' do
      stubs.get('/v1/status/peers') do
        [200, { 'Content-Type' => 'application/json' }, %w[10.1.10.12:8300 10.1.10.11:8300]]
      end
      result = client.peers
      expect(result[:result]).to be_an(Array)
      expect(result[:result].length).to eq(2)
    end
  end
end
