# frozen_string_literal: true

RSpec.describe AdServiceClient do
  describe '.ads' do
    before do
      stub_request(:get, Thinker.ad_service_url)
        .with(
          headers: { 'Accept' => '*/*' }
        )
        .to_return(status: 200, body: { ads: [] }.to_json, headers: {})
    end
    it 'returns hash' do
      expect(subject.ads).to be_instance_of(Hash)
    end
  end

  describe '.connection' do
    it 'returns Faraday::Connection instance' do
      expect(subject.connection).to be_instance_of(Faraday::Connection)
    end
  end
end
