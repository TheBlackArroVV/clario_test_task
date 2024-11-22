# frozen_string_literal: true

RSpec.describe RebillingJob do
  subject(:job) { described_class.run(subscription_id, charged_amount) }

  let(:subscription_id) { 1 }
  let(:charged_amount) { 9.99 }

  describe '#perform' do
    let(:successful_rebill_result) { RebillingService::RESULT.new(:success, {}) }
    let(:insufficient_funds_rebill_result) { RebillingService::RESULT.new(:insufficient_funds, {}) }
    let(:failed_rebill_result) { RebillingService::RESULT.new(:failed, {}) }
    let(:utc_time) { Time.new('2024-11-22 19:58:31.459277459 UTC') }

    before { allow(Time).to receive(:now).and_return(Struct.new(:utc).new(utc_time)) }

    context 'when service returns success' do
      it 'calls Rebilling Service' do
        expect(RebillingService).to receive(:new).with(
          subscription_id, charged_amount
        ).once.and_return(double('RebillingService', call: true, result: successful_rebill_result))

        job
      end
    end

    context 'when service returns insufficient_funds n times' do
      let(:amount_of_insufficient_funds_requests) { (1..3).to_a.sample }

      it 'calls Rebilling Service untill success' do
        amount_of_insufficient_funds_requests.times do |tries|
          expect(RebillingService).to receive(:new).with(
            subscription_id, charged_amount * (1 - (tries * 0.25))
          ).once.and_return(
            double('RebillingService', call: true, result: insufficient_funds_rebill_result)
          )
        end

        expect(RebillingService).to receive(:new).with(
          subscription_id, charged_amount * (1 - (amount_of_insufficient_funds_requests * 0.25))
        ).once.and_return(
          double('RebillingService', call: true, result: successful_rebill_result)
        )

        expect(RebillingJob).to receive(:enqueue).with(
          subscription_id,
          charged_amount - (charged_amount * (1 - (amount_of_insufficient_funds_requests * 0.25))),
          job_options: { run_at: utc_time + 604_800 }
        ).once

        job
      end
    end

    context 'when service returns failed status' do
      before { stub_const('RebillingJob::FIVE_MINUTES', 3) }

      it 'waits and proceeds with execution' do
        expect_any_instance_of(described_class).to receive(:sleep).exactly(4).times.with(3).and_return(true)

        expect(RebillingService).to receive(:new).with(
          subscription_id, charged_amount
        ).and_return(
          double('RebillingService', call: true, result: failed_rebill_result)
        )

        job
      end
    end
  end
end
