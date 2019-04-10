
# This class acts like and ActiveRecord class
class Campaign
  attr_accessor :id, :job_id, :status, :external_reference, :ad_description

  def initialize(ad_hash)
    ad_hash.keys.each{ |key| send("#{key}=",ad_hash[key])}
  end

  class << self

    # Creates <tt>Campaign</tt> instances using mock data which acts like ActiveRecord object.
    # @return [Array<Campaign>]
    def all
      mock.map{ |ad| new(ad) }
    end

    def mock
      [
          { id: 1, job_id: 10, status: 'paused',   external_reference: '1', ad_description: 'Campaign Description' },
          { id: 2, job_id: 11, status: 'paused',   external_reference: '2', ad_description: 'Description for campaign 12' },
          { id: 3, job_id: 12, status: 'active',   external_reference: '3', ad_description: 'Description for campaign 13' },
          { id: 4, job_id: 13, status: 'active',   external_reference: '4', ad_description: 'React Developer' },
          { id: 5, job_id: 14, status: 'deleted',  external_reference: '5', ad_description: 'Full-Stack Developer' },
          { id: 6, job_id: 15, status: 'active',   external_reference: '6', ad_description: 'Ux Designer' }
      ]
    end
  end
end