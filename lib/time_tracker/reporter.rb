require_relative 'work_range'
require 'yaml/store'
require 'date'

module TimeTracker
  class Reporter

    attr_reader :file, :project, :task,
      :start_date, :end_date

    private :file, :project, :task,
      :start_date, :end_date

    def initialize(args)
      @file = ENV['HOURS'] || "#{ENV['HOME']}/.tt"
      @project = args[:project]
      @task = args[:task]
      @start_date = args[:start_date]
      @end_date = args[:end_date]
    end

    def hours_tracked
      store = YAML::Store.new(file)
      if project.nil?
        store.transaction(true) do |s|
          all_hours(s)
        end
      else
        store.transaction(true) do |s|
          if task.nil?
            all_project_task_hours(s)
          else
            project_task_hours(s)
          end
        end
      end
    end

    private

    def all_hours(store)
      hours = {}
      store.roots.each do |p|
        hours[p] = {}
        store[p].each_key do |t|
          hours[p][t] = WorkRange.new(times: store[p][t], start_time: start_date, end_time: end_date).hours
        end
      end
      hours
    end

    def all_project_task_hours(store)
      hours = {}
      hours[project] = {}
      store[project].each_key do |t|
        hours[project][t] = WorkRange.new(times: store[project][t], start_time: start_date, end_time: end_date).hours
      end
      hours
    end

    def project_task_hours(store)
      hours = {}
      hours[project] = {}
      hours[project][task] = WorkRange.new(times: store[project][task], start_time: start_date, end_time: end_date).hours
      hours
    end
  end
end
