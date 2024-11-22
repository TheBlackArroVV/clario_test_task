require 'sequel'

class Database
  include Singleton

  attr_reader :db

  private

  def initialize
    @db = Sequel.connect(
      adapter: :postgres,
      user: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
      host: ENV['DB_HOST'],
      port: ENV['DB_PORT'],
      database: ENV['DB_NAME'],
      max_connections: 10,
    )
  end
end
