require 'spec_helper'
require 'time_tracker/sync'

module TimeTracker
  describe Sync do
    describe 'on_sync' do
      before do
        @file = File.dirname(__FILE__) + "/.ttrc"
        File.delete @file if File.exists?(@file)
        File.open @file, 'w' do |f|
          f.puts "post_url = 'http://www.site.com/api/track'\n\
                  on_sync { |e| post_url }"

        end
        @sync = TimeTracker::Sync.new @file
      end
      after do
        File.delete @file if File.exists?(@file)
      end

      it 'executes block' do
        @sync.call(:tracking_on).
          should eq 'http://www.site.com/api/track'
      end
    end
  end
end
