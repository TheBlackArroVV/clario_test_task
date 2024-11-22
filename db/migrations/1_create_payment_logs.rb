# frozen_string_literal: true

Sequel.migration do
  change do
    create_table? :payment_logs do
      primary_key :id
      BigDecimal :charged_amount
      DateTime :created_at
      Bignum :subscription_id
      String :status
    end
  end
end
