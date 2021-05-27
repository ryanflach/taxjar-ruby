require 'helper'

describe Taxjar::Client do
  describe '#api_key?' do
    it 'returns true if api_key is present' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect(client.api_key?).to be true
    end

    it 'returns false if api_key is not present' do
      client = Taxjar::Client.new
      expect(client.api_key?).to be false
    end
  end

  describe "#set_api_config" do
    it 'sets new api key' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_key', 'ZZ')
      expect(client.api_key).to eq('ZZ')
    end

    it 'sets new api url' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_url', 'https://api.sandbox.taxjar.com')
      expect(client.api_url).to eq('https://api.sandbox.taxjar.com')
    end

    it 'sets new custom headers' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('headers', { 'X-TJ-Expected-Response' => 422 })
      expect(client.headers).to eq({ 'X-TJ-Expected-Response' => 422 })
    end

    it 'sets custom nexus regions when valid format' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('custom_nexus_regions', ['AZ', 'PA', 'CA'])
      expect(client.custom_nexus_regions).to eq(['AZ', 'PA', 'CA'])
    end

    it 'raises on invalid format of custom nexus regions' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect { client.set_api_config('custom_nexus_regions', [123, 'HELLO', nil]) }
        .to raise_error('custom_nexus_regions must be an array of 2-character strings')
    end
  end

  describe "#get_api_config" do
    it 'gets a config value' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_key', 'ZZ')
      expect(client.get_api_config('api_key')).to eq('ZZ')
    end
  end

  describe '#user_agent' do
    it 'returns string with version' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect(client.user_agent).to match(/^TaxJar\/Ruby \(.+\) taxjar-ruby\/\d+\.\d+\.\d+$/)
    end
  end
end
