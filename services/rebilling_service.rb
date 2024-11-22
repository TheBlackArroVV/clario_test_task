# frozen_string_literal: true

require_relative 'base_service'
require_relative 'payment_gateway'
require_relative '../models/payment_log'

class RebillingService < BaseService # :nodoc:
  def call
    payment_gateway.call
    create_payment_log

    @result = RESULT.new(payment_gateway_status, { payment_log: @payment_log })
  end

  private

  attr_reader :subscription_id, :amount_to_charge

  def payment_gateway
    @payment_gateway ||= PaymentGateway.new(subscription_id, amount_to_charge)
  end

  def payment_gateway_status
    @payment_gateway.result.status
  end

  def create_payment_log
    @payment_log = PaymentLog.create(
      charged_amount: amount_to_charge,
      subscription_id:,
      created_at: Time.now.utc,
      status: payment_gateway_status
    )
  end
end
