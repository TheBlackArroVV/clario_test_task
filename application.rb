# frozen_string_literal: true

require 'que'

require_relative 'jobs/rebilling_job'
require_relative 'models/payment_log'
require_relative 'models/que_job'

Que.connection = Database.instance.db
