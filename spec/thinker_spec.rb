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

  describe '.max_network_retries=' do
    it 'updates @max_network_retries instance variable' do
      subject.max_network_retries = '1'
      expect(subject.max_network_retries).to eql(1)
    end
  end

  describe '.open_timeout=' do
    it 'updates @open_timeout instance variable' do
      subject.open_timeout = '1'
      expect(subject.open_timeout).to eql(1)
    end
  end

  describe '.read_timeout=' do
    it 'updates @read_timeout instance variable' do
      subject.read_timeout = '1'
      expect(subject.read_timeout).to eql(1)
    end
  end
end
