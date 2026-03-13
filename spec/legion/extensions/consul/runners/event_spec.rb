# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Runners::Event do
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

  describe '#fire_event' do
    it 'fires a custom event' do
      stubs.put('/v1/event/fire/deploy') do
        [200, { 'Content-Type' => 'application/json' }, { 'ID' => 'evt-123', 'Name' => 'deploy' }]
      end
      result = client.fire_event(name: 'deploy')
      expect(result[:result]['Name']).to eq('deploy')
    end
  end

  describe '#list_events' do
    it 'lists recent events' do
      stubs.get('/v1/event/list') do
        [200, { 'Content-Type' => 'application/json' }, [{ 'ID' => 'evt-123', 'Name' => 'deploy' }]]
      end
      result = client.list_events
      expect(result[:result]).to be_an(Array)
      expect(result[:result].first['Name']).to eq('deploy')
    end
  end
end
