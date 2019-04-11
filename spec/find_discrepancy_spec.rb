# frozen_string_literal: true

RSpec.describe FindDiscrepancy do

  describe '.call' do

    context 'when remote_data is nil' do
      it 'returns empty array' do
        allow(AdServiceClient.connection).to receive(:get).and_raise(Faraday::TimeoutError)
        expect(FindDiscrepancy.call).to eql([])
      end
    end

    context 'when there is discrepancies' do
      it 'returns array with discrepancies' do
        campaign_mock = [
          { id: 1, job_id: 10, status: 'paused', external_reference: '1', ad_description: 'Campaign Description' },
          { id: 2, job_id: 11, status: 'active', external_reference: '2', ad_description: 'Description for campaign 11' },
        ]

        remote_ads = {
            '1' => { reference: '1', status: 'enabled', description: 'Description for campaign 10' },
            '2' => { reference: '2', status: 'enabled', description: 'Description for campaign 11' }
        }

        discrepancy_result = [
            {
                remote_reference: '1',
                remote_existence: true,
                discrepancies: [
                    {
                        remote: 'Description for campaign 10',
                        local: 'Campaign Description',
                        field: 'ad_description'
                    },
                    {
                        remote: 'enabled',
                        local: 'paused',
                        field: 'status'
                    }
                ]
            }
        ]
        allow(Campaign).to receive(:mock).and_return(campaign_mock)
        allow(AdServiceClient).to receive(:ads).and_return(remote_ads)

        expect(FindDiscrepancy.call).to eql(discrepancy_result)
      end
    end

    context 'when there is NOT discrepancies' do
      it 'returns empty array' do
        campaign_mock = [
            { id: 1, job_id: 10, status: 'active', external_reference: '1', ad_description: 'Campaign Description' },
            { id: 2, job_id: 11, status: 'active', external_reference: '2', ad_description: 'Description for campaign 11' },
        ]

        remote_ads = {
            '1' => { reference: '1', status: 'enabled', description: 'Campaign Description' },
            '2' => { reference: '2', status: 'enabled', description: 'Description for campaign 11' }
        }

        allow(Campaign).to receive(:mock).and_return(campaign_mock)
        allow(AdServiceClient).to receive(:ads).and_return(remote_ads)

        expect(FindDiscrepancy.call).to eql([])
      end
    end

  end
end