class Hash # :nodoc
  def symbolize_keys
    transform_keys{ |key| key.to_sym rescue key }
  end
end