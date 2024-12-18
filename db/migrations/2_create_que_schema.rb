# frozen_string_literal: true

require 'que'

Sequel.migration do
  up do
    Que.connection = self
    Que.migrate!(version: 7)
  end
  down do
    Que.connection = self
    Que.migrate!(version: 0)
  end
end
