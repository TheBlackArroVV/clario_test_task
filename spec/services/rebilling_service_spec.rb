# frozen_string_literal: true

RSpec.describe RebillingService do
  subject(:service) { described_class.new(subscription_id, charged_amount) }

  let(:subscription_id) { 1 }
  let(:charged_amount) { 9.99 }

  describe '#call' do
    let(:gateway_double) { double('PaymentGateway', call: true, result: gateway_result) }
    let(:utc_time) { '22.11.2024' }

    before do
      allow(PaymentGateway).to receive(:new).with(subscription_id, charged_amount).and_return(gateway_double)
      allow(Time).to receive(:now).and_return(Struct.new(:utc).new(utc_time))
    end

    context 'when payment gatewy returns success status' do
      let(:gateway_result) { PaymentGateway::RESULT.new(:success, {}) }

      it 'creates payment log with success status' do
        expect(PaymentLog).to receive(:create).with(
          subscription_id:, charged_amount:, status: :success, created_at: utc_time
        ).and_call_original

        expect(service.call).to eq(described_class::RESULT.new(:success, { payment_log: PaymentLog.last }))
        expect(service.result).to be_instance_of(described_class::RESULT)
      end
    end

    context 'when payment gatewy returns insuficient_funds status' do
      let(:gateway_result) { PaymentGateway::RESULT.new(:insuficient_funds, {}) }

      it 'creates payment log with insuficient_funds status' do
        expect(PaymentLog).to receive(:create).with(
          subscription_id:, charged_amount:, status: :insuficient_funds, created_at: utc_time
        ).and_call_original

        expect(service.call).to eq(described_class::RESULT.new(:insuficient_funds, { payment_log: PaymentLog.last }))
        expect(service.result).to be_instance_of(described_class::RESULT)
      end
    end

    context 'when payment gateway returns failed status' do
      let(:gateway_result) { PaymentGateway::RESULT.new(:failed, {}) }

      it 'creates payment log with success status' do
        expect(PaymentLog).to receive(:create).with(
          subscription_id:, charged_amount:, status: :failed, created_at: utc_time
        ).and_call_original

        expect(service.call).to eq(described_class::RESULT.new(:failed, { payment_log: PaymentLog.last }))
        expect(service.result).to be_instance_of(described_class::RESULT)
      end
    end
  end
end
