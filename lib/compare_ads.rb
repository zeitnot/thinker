class CompareAds
  # Fields to be compared. Keys are corresponding to local fields. However, values are corresponding to remote fields.
  TARGET_FIELDS_MAP = { ad_description: :description, status: :status }.freeze
  STATUS_MAP        = { enabled: :active , disabled: :paused }.freeze
  LOCAL_FIELDS      = TARGET_FIELDS_MAP.keys.freeze

  attr_accessor :campaign, :remote_ad

  # @param [Campaing] campaign
  # @param [Hash] remote_ad
  def initialize(campaign:, remote_ad:)
    self.campaign   = campaign
    self.remote_ad  = remote_ad
  end

  # Compares single <tt>Campaign</tt> and a <tt>Hash</tt> from remote data. If there is any discrepancies it returns
  # hash otherwise <tt>nil</tt>.
  # @example When the campaign does not have corresponding remote ad:
  #   { remote_reference: external_id, remote_existence: false, discrepancies: [] }
  # @example When there is any discrepancy:
  #   { remote_reference: '1',
  #     remote_existence: true,
  #     discrepancies: [
  #         {
  #             remote: 'disabled',
  #             local: 'active',
  #             field: 'status'
  #         }
  #     ]
  #   }
  # @see AddServiceClient.ads
  # @return [Hash,nil]
  def compare
    external_id = campaign.external_reference
    return { remote_reference: external_id, remote_existence: false, discrepancies: [] } unless remote_ad

    discrepancies = []
    LOCAL_FIELDS.each do |field|
      local_value   = campaign.send(field).to_s

      if field == :status
        remote_value  = STATUS_MAP[remote_ad[:status].to_sym]
        remote_value  = remote_ad[:status] unless remote_value # Hash may return nil in case of unknown status.
      else
        remote_value  = remote_ad[TARGET_FIELDS_MAP[field]]
      end

      remote_value = remote_value.to_s

      next if  local_value == remote_value

      # Rollback to old value if it is status
      remote_value = remote_ad[:status] if field == :status

      discrepancies << {
          remote: remote_value,
          local: local_value,
          field: field.to_s
      }
    end

    { remote_reference: external_id, remote_existence: true ,discrepancies: discrepancies } if discrepancies.any?
  end

  class << self
    # @see #compare
    def call(**args)
      new(**args).compare
    end
  end
end