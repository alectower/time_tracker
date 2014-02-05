require 'spec_helper'
require 'time_tracker/reporter'

module TimeTracker
  describe Reporter do
    before do
      ENV['HOURS'] = "#{File.dirname(__FILE__)}/hours"
      store = YAML::Store.new(ENV['HOURS'])
      store.transaction do |s|
        s[:project_one] = {
          task_one: [
            Time.parse("2014-01-01 08:00:00 -05:00"),
            Time.parse("2014-01-01-09:00:00 -05:00"),
            Time.parse("2014-01-02-14:00:00 -05:00"),
            Time.parse("2014-01-02-20:00:00 -05:00"),
            Time.parse("2014-01-03-08:00:00 -05:00")
          ],
          task_two: [
            Time.parse("2014-01-01 01:00:00 -0500"),
            Time.parse("2014-01-01 03:00:00 -0500")
          ]
        }
        s[:project_two] = {
          task_one: [
            Time.parse("2014-01-01 05:00:00 -0500"),
            Time.parse("2014-01-01 15:00:00 -0500")
          ]
        }
      end
    end

    after do
      File.delete ENV['HOURS']
    end

    it 'reports total hours for all tasks of all project' do
      expected = {
        project_one: {
          task_one: {
            total_hours: 23.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(1, 1),
              Date.new(2014,1,2) => Rational(6, 1),
              Date.new(2014,1,3) => Rational(16, 1),
            }
          },
          task_two: {
            total_hours: 2.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(2, 1),
            }
          }
        },
        project_two: {
          task_one: {
            total_hours: 10.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(10, 1),
            }
          },
        }
      }
      Reporter.hours_tracked(nil, nil, Time.new(2014,1,1), Time.new(2014,1,4)).should eq expected
      Reporter.hours_tracked(nil, :task_one, Time.new(2014,1,1), Time.new(2014,1,4)).should eq expected
    end

    it 'reports total hours for all tasks of a project' do
      expected = {
        project_one: {
          task_one: {
            total_hours: 23.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(1, 1),
              Date.new(2014,1,2) => Rational(6, 1),
              Date.new(2014,1,3) => Rational(16, 1),
            }
          },
          task_two: {
            total_hours: 2.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(2, 1),
            }
          }
        }
      }
      Reporter.hours_tracked(:project_one, nil, Time.new(2014,1,1), Time.new(2014,1,4)).should eq expected
    end

    it 'reports total hours for one task of a project' do
      expected = {
        project_one: {
          task_one: {
            total_hours: 23.0,
            daily_hours: {
              Date.new(2014,1,1) => Rational(1, 1),
              Date.new(2014,1,2) => Rational(6, 1),
              Date.new(2014,1,3) => Rational(16, 1),
            }
          },
        }
      }
      Reporter.hours_tracked(:project_one, :task_one, Time.new(2014,1,1), Time.new(2014,1,4)).should eq expected
    end
  end
end
