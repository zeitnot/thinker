# frozen_string_literal: true

RSpec.describe Hash do
  describe '#symbolize_keys' do
    context 'when key is not string or symbol' do
      it 'does not do conversion' do
        hash = { [] => true }.symbolize_keys
        expect(hash).to eql(hash)
      end
    end
  end
end