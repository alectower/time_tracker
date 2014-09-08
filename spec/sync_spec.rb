require 'spec_helper'
require 'time_tracker/sync'

module TimeTracker
  describe Sync do
    describe 'on_sync' do
      before do
        @file = File.dirname(__FILE__) + "/.ttrc"
        File.delete @file if File.exists?(@file)
        File.open @file, 'w' do |f|
          f.puts "@api_url = 'http://www.site.com/api'"
        end
        @sync = TimeTracker::Sync.new @file
      end
      after do
        File.delete @file if File.exists?(@file)
      end

      it 'creates api_url accessor' do
        @sync.api_url.should eq 'http://www.site.com/api'
      end
    end
  end
end
