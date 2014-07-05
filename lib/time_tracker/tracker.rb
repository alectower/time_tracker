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
      row = EntryLog.where project_name: project,
        task_name: task,
        description: description,
        start_time: 'is not null',
        stop_time: 'is null'
      id = if row.size > 0
        EntryLog.update id: row.first['id'],
          stop_time: time
        row.first['id']
      else
        EntryLog.insert start_time: time,
          stop_time: nil,
          entry_id: nil,
          description: description,
          task_id: nil,
          task_name: task,
          project_id: nil,
          project_name: project
      end
      EntryLog.where(id: id).first
    end
  end
end
