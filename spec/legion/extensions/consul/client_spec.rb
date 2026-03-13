# frozen_string_literal: true

RSpec.describe Legion::Extensions::Consul::Client do
  subject(:client) { described_class.new(url: 'http://consul.test:8500', token: 'test-token') }

  it 'stores connection options' do
    expect(client.opts[:url]).to eq('http://consul.test:8500')
    expect(client.opts[:token]).to eq('test-token')
  end

  it 'returns a Faraday connection' do
    expect(client.connection).to be_a(Faraday::Connection)
  end

  it 'sets the X-Consul-Token header when token provided' do
    conn = client.connection
    expect(conn.headers['X-Consul-Token']).to eq('test-token')
  end
end
