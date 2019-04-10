# @see #call
class FindDiscrepancy
  attr_accessor :remote_data, :discrepancies

  def initialize
    self.remote_data    = AdServiceClient.ads
    self.discrepancies  = []
  end

  # This method finds the discrepancies between <tt>Campaign</tt> entity and remote ad.
  # The returned result is <tt>Array</tt> of <tt>Hash</tt> if there is any discrepancies. Otherwise the result will be
  # empty <tt>Array</tt>. In the payload, there is special key which is <tt>remote_existence</tt>. This means that if
  # the <tt>Campaign</tt> entity does not have a corresponding remote ad then the value will be <tt>false</tt> and the
  # <tt>discrepancies</tt> key will be empty array.
  # @example
  #     [
  #         {
  #             :remote_reference => "1",
  #             :remote_existence => true,
  #             :discrepancies => [
  #                 {
  #                     local: 'Description for campaign 10',
  #                     remote: 'Campaign Description',
  #                     field: 'ad_description'
  #                 },
  #                 {
  #                     local: 'paused',
  #                     remote: 'enabled',
  #                     field: 'status'
  #                 }
  #             ]
  #         },
  #         { :remote_reference => "4", :remote_existence => false, :discrepancies => [] },
  #         { :remote_reference => "5", :remote_existence => false, :discrepancies => [] },
  #         { :remote_reference => "6", :remote_existence => false, :discrepancies => [] }
  #     ]
  # @return [Array<Hash>]
  def call
    Campaign.all.each do |campaign|
      remote_ad   = remote_data[campaign.external_reference]
      result      = CompareAds.call(campaign: campaign, remote_ad: remote_ad)
      discrepancies << result if result
    end
    discrepancies
  end

  class << self
    # @see #call
    def call
      new.call
    end

  end
end