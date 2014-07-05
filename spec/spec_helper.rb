$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib/time_tracker'))
require 'rspec'
require 'db'

ENV['TT_ENV'] = 'test'

RSpec.configure do |config|
  db = TimeTracker::DB.new

  config.after :each do
    db.execute "delete from entry_logs"
  end

  config.after :suite do
    File.delete db.path
  end
end
