require 'yaml/store'

module TimeTracker
  class Tracker

    attr_reader :store, :project, :task
    private :store, :project, :task

    def initialize(args)
      file = ENV['HOURS'] || "#{ENV['HOME']}/.tt"
      @store = YAML::Store.new(file)
      @project = args[:project]
      @task = args[:task] || 'general'
    end

    def track
      store.transaction do |s|
        project_tasks = s[project]
        s[project] = {} unless project_tasks
        track_tasks(s, project, task)
        s[project][task].size
      end
    end

    private

    def track_tasks(store, project, task)
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
