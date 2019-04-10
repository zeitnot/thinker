RSpec.describe Campaign do
  subject { Campaign }

  describe '.mock' do
    it 'returns not empty array' do
      expect(subject.mock).to be_instance_of(Array)
      expect(subject.mock).to be_any
    end
  end

  describe '.all' do
    it 'returns array of Campaign instances' do
      expect(subject.all).to be_instance_of(Array)

      campaign  = subject.all.first
      expect(campaign).to be_instance_of(Campaign)

      mock_hash = subject.mock.first
      mock_hash.keys do |key|
        expect(campaign.send(key)).to eql(mock_hash[key])
      end
    end
  end
end