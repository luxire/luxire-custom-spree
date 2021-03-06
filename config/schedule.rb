# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/#{path}/log/cron.log"
set :environment, "development"
# every 1.day, :at => '02:47 pm' do
#     runner "Currency.populate", environment => "development"
# end

every '0 4,10,16,22 * * * *' do
            rake 'spree_braintree_vzero:update_states'
          end