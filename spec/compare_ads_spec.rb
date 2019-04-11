# frozen_string_literal: true

RSpec.describe CompareAds do
  subject { CompareAds }

  describe '.call' do
    context 'when remote ad does not exist' do
      it 'returns hash contains remote_existence as false' do
        campaign    = Campaign.new(id: 1, job_id: 1, status: 'active', external_reference: '1', ad_description: 'desc')
        remote_ad   = nil
        discrepancy = { remote_reference: '1', remote_existence: false, discrepancies: [] }

        expect(subject.call(campaign: campaign, remote_ad: remote_ad )).to eql(discrepancy)
      end
    end

    context 'when remote ad exists' do
      context 'when there is no discrepancy' do
        it 'returns nil' do
          campaign    = Campaign.new(id: 1, job_id: 1, status: 'active', external_reference: '1', ad_description: 'desc')
          remote_ad   = { status: 'enabled', reference: '1', description: 'desc' }

          expect(subject.call(campaign: campaign, remote_ad: remote_ad )).to be_nil
        end
      end

      context 'when there is discrepancy' do
        context 'when remote status is unknown' do
          it 'returns hash including discrepancy' do
            campaign    = Campaign.new(id: 1, job_id: 1, status: 'active', external_reference: '1', ad_description: 'desc')
            remote_ad   = { status: 'unknown', reference: '1', description: 'desc' }
            discrepancy = { remote_reference: '1', remote_existence: true, discrepancies: [
                { remote: 'unknown', local: 'active', field: 'status' }
            ] }

            expect(subject.call(campaign: campaign, remote_ad: remote_ad )).to eql(discrepancy)
          end
        end

        context 'when remote status is known' do
          it 'returns hash including discrepancy' do
            campaign    = Campaign.new(id: 1, job_id: 1, status: 'active', external_reference: '1', ad_description: 'desc')
            remote_ad   = { status: 'disabled', reference: '1', description: 'remote desc' }
            discrepancy = { remote_reference: '1', remote_existence: true, discrepancies: [
                { remote: 'remote desc', local: 'desc', field: 'ad_description' },
                { remote: 'disabled', local: 'active', field: 'status' },
            ] }

            expect(subject.call(campaign: campaign, remote_ad: remote_ad )).to eql(discrepancy)
          end
        end
      end
    end
  end
end