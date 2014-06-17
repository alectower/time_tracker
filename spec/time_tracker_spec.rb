require 'spec_helper'

module TimeTracker
  describe Tracker do
    before do
      ENV['HOURS'] = "#{File.dirname(__FILE__)}/.hours"
    end

    after do
      File.delete ENV['HOURS'] if File.exists? ENV['HOURS']
    end

    it 'logs timestamps' do
      Tracker.new(project: 'project', task: 'task').track.size.should eq 1
      Tracker.new(project: 'project', task: 'task').track.size.should eq 2
    end
  end
end
