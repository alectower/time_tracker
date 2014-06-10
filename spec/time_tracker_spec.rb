require 'spec_helper'

module TimeTracker
  describe Tracker do
    before do
      ENV['HOURS'] = "#{File.dirname(__FILE__)}/hours"
    end

    after do
      File.delete ENV['HOURS'] if File.exists? ENV['HOURS']
    end

    it 'tracks number of timestamps for project task' do
      Tracker.new(project: 'project', task: 'task').track.should eq 1
      Tracker.new(project: 'project', task: 'task').track.should eq 2
    end
  end
end
