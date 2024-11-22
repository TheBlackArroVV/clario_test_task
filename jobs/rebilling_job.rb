# frozen_string_literal: true

require 'que'
require_relative '../services/rebilling_service'

# This class is responsible for retrying a rebilling process
# How it works:
# - It receives a subscription_id and an amount_to_charge
# - It will try to charge the amount_to_charge to the subscription_id
# - If the charge is successful, it will destroy the job
# - If the charge fails due to insufficient funds, it will retry the charge with a smaller amount
# - If the charge fails for any other reason, it will wait 5 minutes and try again
# - It will retry the charge up to 4 times
# - If the charge is successful, but the amount charged is different from the amount_to_charge,
#   it will enqueue a new job with the remaining amount to charge in 1 week
class RebillingJob < Que::Job
  FIVE_MINUTES = 5 * 60
  MAX_RETRIES = 4
  SECONDS_PER_WEEK = 604_800
  STEP = 0.25

  def run(subscription_id, amount_to_charge) # rubocop:disable Metrics/MethodLength
    @subscription_id = subscription_id
    @amount_to_charge = amount_to_charge
    @tries = 0

    while @tries < MAX_RETRIES
      rebilling_service.call

      case rebilling_service.result.status
      when :success
        @rebilling_service = nil
        break
      when :insufficient_funds
        @tries += 1
        @rebilling_service = nil
      when :failed
        sleep(FIVE_MINUTES)
        @tries += 1
      end
    end

    destroy
    enqueue_follow_up_job
  end

  private

  attr_reader :amount_to_charge, :subscription_id

  def rebilling_service
    @rebilling_service ||= RebillingService.new(subscription_id, charged_amount)
  end

  def charged_amount
    amount_to_charge * (1 - (@tries * STEP))
  end

  def enqueue_follow_up_job
    return unless amount_to_charge != charged_amount

    RebillingJob.enqueue(
      subscription_id,
      amount_to_charge - charged_amount,
      job_options: { run_at: Time.now.utc + SECONDS_PER_WEEK }
    )
  end
end
