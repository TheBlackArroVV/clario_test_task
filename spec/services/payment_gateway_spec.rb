# frozen_string_literal: true

RSpec.describe PaymentGateway do
  subject(:gateway) { described_class.new(subscription_id, charged_amount) }

  let(:subscription_id) { 1 }
  let(:charged_amount) { 9.99 }

  describe '#call' do
    it 'returns one of the possible results' do
      # nothing much to test here as we only return random value, but if somebody will start returning wrong value
      # we will catch it here(eventually)
      expect(%i[success insuficient_funds failed]).to include(gateway.call.status)
      expect(gateway.result).to be_instance_of(PaymentGateway::RESULT)
    end
  end
end
