namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |_t, args|
    require 'sequel'

    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(
      adapter: :postgres,
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
      host: ENV['DB_HOST'],
      port: ENV['DB_PORT'],
      database: ENV['DB_NAME'],
      max_connections: 10,
    ) do |db|
      Sequel::Migrator.run(db, 'db/migrations', target: version)
    end
  end
end
