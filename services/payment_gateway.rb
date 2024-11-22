# frozen_string_literal: true

require_relative 'base_service'

class PaymentGateway < BaseService # :nodoc:
  def call
    # Generally speaking this would be a call to an external service,
    # but as we don't have one, we'll just return a random status
    # HTTParty.post(
    # 'http://payment-gateway.com/paymentIntents/create',
    # body: { subscription_id: @subscription_id, amount: @amount_to_charge }
    # )
    @result = RESULT.new(%i[success insufficient_funds failed].sample, {})
  end
end
