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
      entries = EntryLog.where(project_name: project,
        task_name: task,
        entry_description: description).where(
          'started_at is not null AND ended_at is null'
        )
      if entries.count == 1
        e = entries.first
        e.ended_at = time
        e.save
      elsif entries.count > 1
        fail 'Multiple entries found with null stop time'
      else
        EntryLog.create started_at: time,
          entry_description: description,
          task_name: task,
          project_name: project
      end
    end
  end
end
