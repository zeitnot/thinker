# frozen_string_literal: true

# :reek:IrresponsibleModule
class Hash # :nodoc:
  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

  def symbolize_keys
    transform_keys do |key|
      begin
        key.to_sym
      rescue StandardError
        key
      end
    end
  end
end
