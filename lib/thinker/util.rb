# frozen_string_literal: true

# :reek:IrresponsibleModule
class Hash # :nodoc:
  def symbolize_keys
    transform_keys do |key|
      key.to_sym
    rescue StandardError
      key
    end
  end
end
