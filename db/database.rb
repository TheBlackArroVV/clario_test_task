# frozen_string_literal: true

require 'sequel'
require 'que'

module Database # :nodoc:
  Sequel.connect(
    adapter: :postgres,
    user: ENV.fetch('DB_USER', nil),
    password: ENV.fetch('DB_PASSWORD', nil),
    host: ENV.fetch('DB_HOST', nil),
    port: ENV.fetch('DB_PORT', nil),
    database: ENV.fetch('DB_NAME', nil),
    max_connections: 10
  )
end
