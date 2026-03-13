# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Kv do
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

  describe '#get_key' do
    it 'reads a key from the KV store' do
      stubs.get('/v1/kv/my-key') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'Key' => 'my-key', 'Value' => 'dGVzdA==' }]]
      end
      result = client.get_key(key: 'my-key')
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['Key']).to eq('my-key')
    end
  end

  describe '#put_key' do
    it 'writes a key to the KV store' do
      stubs.put('/v1/kv/my-key') { [200, { 'Content-Type' => 'application/json' }, true] }
      result = client.put_key(key: 'my-key', value: 'test-value')
      expect(result[:result]).to be true
    end
  end

  describe '#delete_key' do
    it 'deletes a key from the KV store' do
      stubs.delete('/v1/kv/my-key') { [200, { 'Content-Type' => 'application/json' }, true] }
      result = client.delete_key(key: 'my-key')
      expect(result[:result]).to be true
    end
  end

  describe '#list_keys' do
    it 'lists keys with a prefix' do
      stubs.get('/v1/kv/app/') do
        [200, { 'Content-Type' => 'application/json' }, %w[app/db app/cache app/web]]
      end
      result = client.list_keys(prefix: 'app/')
      expect(result[:result]).to eq(%w[app/db app/cache app/web])
    end
  end
end
