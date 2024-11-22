# frozen_string_literal: true

require 'que'
require 'sequel'

require_relative 'rebilling_job'

# Set Que's connection to the Sequel database
Que.connection = Database.instance.db

job_buffer = Que::JobBuffer.new(maximum_size: 10, priorities: [Que::MAXIMUM_PRIORITY])
result_queue = Que::ResultQueue.new

# Start the Que worker
Que::Worker.new(job_buffer: job_buffer, result_queue: result_queue, priority: Que::MAXIMUM_PRIORITY)
