ENV['TT_ENV'] = 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib/time_tracker'))
require 'rspec'

require 'db'
require 'entry_log'

RSpec.configure do |config|
  config.before :each do
    TimeTracker::EntryLog.dataset.delete
  end

  config.after :suite do
    File.delete TimeTracker::DB.path
  end
end
