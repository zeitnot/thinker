# frozen_string_literal: true

# This class is responsible for comparing <tt>Campaign</tt> and a hash value that contains remote ad details.
class CompareAds
  attr_reader :campaign, :remote_ad

  # @param [Campaing] campaign
  # @param [Hash] remote_ad
  def initialize(campaign:, remote_ad:)
    @campaign   = campaign
    @remote_ad  = remote_ad
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
  # @return [Hash,nil] returns nil if there is no discrepancy
  def compare
    external_id = campaign.external_reference
    # Remote ad does not exist.
    return { remote_reference: external_id, remote_existence: false, discrepancies: [] } unless remote_ad

    discrepancies = []
    Thinker::LOCAL_FIELDS.each do |field|
      local_value   = campaign.send(field)
      is_status     = field == :status
      remote_status = remote_ad[:status]

      if is_status
        remote_value = Thinker::STATUS_MAP[remote_status.to_sym].to_s
        remote_value ||= remote_status # Thinker::STATUS_MAP may return nil in case of unknown status.
      else
        remote_value = remote_ad[Thinker::TARGET_FIELDS_MAP[field]]
      end

      next if  local_value == remote_value

      # Rollback to old value if it is status
      remote_value = remote_status if is_status

      discrepancies << { remote: remote_value, local: local_value, field: field.to_s }
    end

    { remote_reference: external_id, remote_existence: true, discrepancies: discrepancies } if discrepancies.any?
  end

  class << self
    # @see #compare
    def call(**args)
      new(**args).compare
    end
  end
end
