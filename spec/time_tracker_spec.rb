require 'spec_helper'

module TimeTracker
  describe Tracker do
    before do
      ENV['HOURS'] = "#{File.dirname(__FILE__)}/hours"
    end

    after do
      File.delete ENV['HOURS']
    end

    it 'tracks project hours by task' do
      Tracker.track('project', 'task').should eq 1
      Tracker.track('project', 'task').should eq 2
    end
  end

end
