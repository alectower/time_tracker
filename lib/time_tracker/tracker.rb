require 'yaml/store'

module TimeTracker
  class Tracker

    def self.file
      ENV['HOURS'] || "#{ENV['HOME']}/.tt"
    end

    def self.track(project, task)
      abort 'project argument required' unless project
      task = 'general' unless task
      store = YAML::Store.new(file)
      store.transaction do |s|
        project_tasks = s[project]
        s[project] = {} unless project_tasks
        track_tasks(s, project, task)
        s[project][task].size
      end
    end

    def self.track_tasks(store, project, task)
      time = Time.now
      tasks = store[project][task]
      if tasks
        tasks << time
      else
        store[project][task] = [time]
      end
    end

  end
end
