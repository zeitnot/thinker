# frozen_string_literal: true

RSpec.describe Thinker do
  it 'responds to ad_service_url method' do
    expect(subject.ad_service_url).to be_instance_of(String)
  end

  describe '.ad_service_url=' do
    it 'updates @ad_service_url instance variable' do
      subject.ad_service_url = url = 'http://example.com'
      expect(subject.ad_service_url).to eql(url)
    end
  end
end
