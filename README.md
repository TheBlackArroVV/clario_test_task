How to start a project:
1. Copy .env.example to .env and fill in the necessary information
2. Run `docker-compose up -d` to start the project dependencies
3. Run migrations `bundle exec rake "db:migrate[2]"`
4. Run que locally `bundle exec que ./jobs/worker.rb`
5. Open irb `irb -I . -r application.rb`
6. Schedule a job `RebillingJob.enqueue(1, 9.99)`
7. To check the logs for job check events saved in `PaymentLog` table, something like `PaymentLog.all`
8. To check the status of the job `Que::Job.all`

To run specs simply run `bundle exec rspec`
