require 'spec_helper'
require 'time_tracker/reporter'

module TimeTracker
  describe Reporter do
    before do
      EntryLog.create started_at: 1388581200,
        ended_at: 1388584800,
        project_name: :project_one,
        task_name: :task_one,
        entry_description: 'task one piece'
      EntryLog.create started_at: 1388588400,
        ended_at: 1388592000,
        project_name: :project_one,
        task_name: :task_two,
        entry_description: 'task two piece'
      EntryLog.create started_at: 1388595600,
        ended_at: 1388599200,
        project_name: :project_two,
        task_name: :task_one,
        entry_description: 'task one piece'
    end

    it 'reports total hours for all tasks of all project' do
      expected = {
        total: 3,
        "project_one" => {
          "task_one" => {
            "task one piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          },
          "task_two" => {
            "task two piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          }
        },
        "project_two" => {
          "task_one" => {
            "task one piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          }
        }
      }
      Reporter.new(start_date: Time.new(2014,1,1), end_date: Time.new(2014,1,4)).hours_tracked.should eq expected
      Reporter.new(task: :task_one, start_date: Time.new(2014,1,1), end_date: Time.new(2014,1,4)).hours_tracked.should eq expected
    end

    it 'reports total hours for all tasks of a project' do
      expected = {
        total: 2.0,
        "project_one" => {
          "task_one" => {
            "task one piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          },
          "task_two" => {
            "task two piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          }
        }
      }
      Reporter.new(project: :project_one, start_date: Time.new(2014,1,1), end_date: Time.new(2014,1,4)).hours_tracked.should eq expected
    end

    it 'reports total hours for one task of a project' do
      expected = {
        total: 1.0,
        "project_one" => {
          "task_one" => {
            "task one piece" => {
              Date.new(2014,1,1) => 1.0
            },
            total: 1.0
          },
        }
      }
      Reporter.new(project: :project_one, task: :task_one, start_date: Time.new(2014,1,1), end_date: Time.new(2014,1,4)).hours_tracked.should eq expected
    end
  end
end
