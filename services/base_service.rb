class BaseService
  RESULT = Struct.new(:status, :response_body)

  attr_reader :result

  def initialize(subscription_id, amount_to_charge)
    @subscription_id = subscription_id
    @amount_to_charge = amount_to_charge
    @result = nil
  end
end
