# frozen_string_literal: true

require 'sequel'

module Database # :nodoc:
  Sequel.connect(
    adapter: :postgres,
    user: ENV['DB_USER'],
    password: ENV['DB_PASSWORD'],
    host: ENV['DB_HOST'],
    port: ENV['DB_PORT'],
    database: ENV['DB_NAME'],
    max_connections: 10
  )
end
