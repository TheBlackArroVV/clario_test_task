# frozen_string_literal: true

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_t, args|
    require 'sequel'

    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(
      adapter: :postgres,
      user: ENV.fetch('DB_USER', nil),
      password: ENV.fetch('DB_PASSWORD', nil),
      host: ENV.fetch('DB_HOST', nil),
      port: ENV.fetch('DB_PORT', nil),
      database: ENV.fetch('DB_NAME', nil),
      max_connections: 10
    ) do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end
end
