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
      id = if entries.size == 1
        EntryLog.update id: entries.first.id,
          stop_time: time
        entries.first.id
      elsif entries.size > 1
        fail 'Multiple entries found with null stop time'
      else
        EntryLog.insert(start_time: time,
          stop_time: nil,
          entry_id: nil,
          description: description,
          task_id: nil,
          task_name: task,
          project_id: nil,
          project_name: project).id
      end
      EntryLog.where(id: id).first
    end
  end
end
