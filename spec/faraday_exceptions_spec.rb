RSpec.describe 'Faraday Exceptions' do

  context 'client specific errors' do
    context 'and response status is 40x' do
      it 'fails silently' do
        stub_request(:get, Thinker.ad_service_url)
            .with(headers: { 'Accept' => '*/*' })
            .to_return(status: 422, body: '', headers: {})


        expect(AdServiceClient.ads).to be_nil
      end
    end

    context 'and response status is 50x' do
      it 'fails silently' do
        source = :sentinels
        stub_request(:get, Thinker.ad_service_url)
            .with(headers: { 'Accept' => '*/*' })
            .to_return(status: 503, body: '', headers: {})

        expect(AdServiceClient.ads).to be_nil
      end
    end
  end

  context 'network specific errors' do
    context 'and it is Faraday::TimeoutError' do
      it 'fails silently' do
        exception_class = Faraday::TimeoutError
        allow(AdServiceClient.connection).to receive(:get).and_raise(exception_class)
        expect(AdServiceClient.ads).to be_nil
      end
    end

    context 'and it is Faraday::ConnectionFailed' do
      xit 'fails silently' do
        exception_class = Faraday::ClientError
        allow(AdServiceClient.connection).to receive(:get).and_raise(exception_class)
        expect(AdServiceClient.ads).to be_nil
      end
    end

    context 'and it is unknown exception' do
      it 'raises exception and terminates the program' do
        exception_class = ZeroDivisionError
        allow(AdServiceClient.connection).to receive(:get).and_raise(exception_class)
        expect{ AdServiceClient.ads }.to raise_error(exception_class)
      end
    end
  end
end