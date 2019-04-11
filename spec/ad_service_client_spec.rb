# frozen_string_literal: true

RSpec.describe AdServiceClient do
  describe '.ads' do
    context 'when JSON is ok' do
      before do
        stub_request(:get, Thinker.ad_service_url)
            .with(
                headers: { 'Accept' => '*/*' }
            )
            .to_return(status: 200, body: File.read(Pathname.new('spec/data/remote_ad.json')), headers: {})

        @ads = subject.ads
      end

      it 'returns hash' do
        expect(@ads).to be_instance_of(Hash)
      end

      it 'returns 3 ads' do
        expect(@ads.size).to be(3)
      end

      it 'includes 2 enabled ads' do
        enabled_size = @ads.each_value.select{ |value| value[:status] == 'enabled' }.count
        expect(enabled_size).to be(2)
      end
    end

    context 'when JSON is malformed' do
      it 'returns nil' do
        stub_request(:get, Thinker.ad_service_url)
            .with(
                headers: { 'Accept' => '*/*' }
            )
            .to_return(status: 200, body: 'Malformed JSON', headers: {})

        expect(subject.ads).to be_nil
      end
    end
  end

  describe '.connection' do
    it 'returns Faraday::Connection instance' do
      expect(subject.connection).to be_instance_of(Faraday::Connection)
    end
  end
end
