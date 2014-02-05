require_relative 'work_range'
require 'yaml/store'
require 'date'

module TimeTracker
  class Reporter

    def self.file
      ENV['HOURS'] || "#{ENV['HOME']}/.tt"
    end

    def self.hours_tracked(project, task, start_date, end_date)
      hours = {}
      store = YAML::Store.new(file)
      if project.nil?
        store.transaction(true) do |s|
          s.roots.each do |p|
            hours[p] = {}
            s[p].each_key do |t|
              hours[p][t] = WorkRange.hours s[p][t], start_date, end_date
            end
          end
        end
      else
        store.transaction(true) do |s|
          if task.nil?
            hours[project] = {}
            s[project].each_key do |t|
              hours[project][t] = WorkRange.hours s[project][t], start_date, end_date
            end
          else
            hours[project] = {}
            hours[project][task] = WorkRange.hours s[project][task], start_date, end_date
          end
        end
      end
      hours
    end
  end
end
