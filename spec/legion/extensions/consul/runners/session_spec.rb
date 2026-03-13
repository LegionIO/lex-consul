# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Session do
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

  describe '#create_session' do
    it 'creates a new session' do
      stubs.put('/v1/session/create') do
        [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'adf4238a-882b-9ddc-4a9d-5b6758e4159e' }]
      end
      result = client.create_session(name: 'my-lock', ttl: '30s')
      expect(result[:result]['ID']).to eq('adf4238a-882b-9ddc-4a9d-5b6758e4159e')
    end
  end

  describe '#destroy_session' do
    it 'destroys a session' do
      stubs.put('/v1/session/destroy/abc-123') { [200, { 'Content-Type' => 'application/json' }, true] }
      result = client.destroy_session(id: 'abc-123')
      expect(result[:result]).to be true
    end
  end

  describe '#list_sessions' do
    it 'lists all sessions' do
      stubs.get('/v1/session/list') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'abc-123', 'Name' => 'my-lock' }]]
      end
      result = client.list_sessions
      expect(result[:result].first['Name']).to eq('my-lock')
    end
  end

  describe '#renew_session' do
    it 'renews a session' do
      stubs.put('/v1/session/renew/abc-123') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'abc-123', 'TTL' => '30s' }]]
      end
      result = client.renew_session(id: 'abc-123')
      expect(result[:result].first['ID']).to eq('abc-123')
    end
  end
end
