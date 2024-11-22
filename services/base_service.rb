class BaseService
  RESULT = Struct.new(:status, :response_body)

  attr_reader :result

  def initialize(subscription_id, charged_amount)
    @subscription_id = subscription_id
    @charged_amount = charged_amount
    @result = nil
  end
end
