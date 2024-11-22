# frozen_string_literal: true

require_relative 'base_service'

class PaymentGateway < BaseService # :nodoc:
  def call
    # Generally speaking this would be a call to an external service,
    # but as we don't have one, we'll just return a random status
    @result = RESULT.new(%i[success insuficient_funds failed].sample, {})
  end
end
