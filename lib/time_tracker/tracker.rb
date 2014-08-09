require_relative 'entry_log'

module TimeTracker
  class Tracker

    attr_reader :project, :task, :description
    private :project, :task, :description

    def initialize(args)
      fail 'Project name required' unless !args[:project].nil?
      fail 'Task name required' unless !args[:task].nil?
      @project = args[:project]
      @task = args[:task]
      @description = args[:description] || 'general'
    end

    def track
      time = Time.now.to_i
      entries = EntryLog.where project_name: project,
        task_name: task,
        description: description,
        start_time: 'is not null',
        stop_time: 'is null'
      if entries.size == 1
        e = entries.first
        e.stop_time = time
        e.save
      elsif entries.size > 1
        fail 'Multiple entries found with null stop time'
      else
        EntryLog.new(start_time: time,
          description: description,
          task_name: task,
          project_name: project).save
      end
    end
  end
end
