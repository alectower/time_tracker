require 'spec_helper'
require 'time_tracker/tracker'

module TimeTracker
  describe Tracker do
    it 'creates entry with project name' do
      Tracker.new(project: 'project', task: 'task').
        track.project_name.should eq 'project'
    end

    it 'creates entry with task name' do
      Tracker.new(project: 'project', task: 'task').
        track.task_name.should eq 'task'
    end

    it 'creates entry with description' do
      Tracker.new(project: 'project', task: 'task',
        description: 'description').track.entry_description.
          should eq 'description'
    end

    it 'creates first entry with nil stop time' do
      Tracker.new(project: 'project',
        task: 'task').track.ended_at.should eq nil
    end

    it 'adds stop time to entry' do
      e = Tracker.new(project: 'project', task: 'task').track
      e.ended_at.should eq nil
      ent = Tracker.new(project: 'project', task: 'task').track
      ent.ended_at.should_not eq nil
      e.id.should eq ent.id
    end
  end
end
