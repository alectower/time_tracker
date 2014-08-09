require 'optparse'
require_relative 'time_tracker/sync'
require_relative 'time_tracker/tracker'
require_relative 'time_tracker/reporter'

module TimeTracker
  class CLI
    attr_reader :sync

    def initialize
      @sync = Sync.new
    end

    def process
      command = ARGV.shift
      case command
      when 'track'
        track_time
      when 'hours'
        print_hours
      when 'sync'
        sync.call EntryLog.unsynced
      else
        print_options
      end
    end

    private

    def track_time
      project, task, description = project_args
      entry_log = Tracker.new(project: project,
        task: task, description: description).track
      if entry_log.stop_time.nil?
        puts "on the clock"
      else
        puts "off the clock"
        sync.call EntryLog.unsynced
      end
    end

    def project_args
      project_task = ARGV.shift
      project, task, description = project_task.split ':'
      fail 'Project' unless !project.nil? && !project.empty?
      [project, task, description]
    end

    def print_hours
      if ARGV.size % 2 != 0
        project, task, description = project_args
      end
      while arg = ARGV.shift
        case arg
        when /-s|--start/
          start_date = get_start_date
        when /-e|--end/
          end_date = get_end_date
        end
      end
      project_hours = Reporter.new(
        project: project,
        task: task,
        description: description,
        start_date: start_date,
        end_date: end_date
      ).hours_tracked
      print_projects(project_hours)
    end

    def print_options
      puts "\n\tUsage: time_tracker <command> [project]:[task]:[description] [OPTIONS]\n\n\
        Commands\n\
            track        track time for project tasks\n\
            hours        print hours tracked for project tasks in date range\n\

        Options\n\
            -s, --start <YYYY-MM-DD>    used with hours command
            -e, --end <YYYY-MM-DD>      used with hours command\n\n\
        Examples\n\
            time_tracker track company:api\n\
            time_tracker track company:api\n\
            time_tracker track company:frontend\n\
            time_tracker track company:frontend\n\
            time_tracker track company:frontend:'Update hover css'\n\
            time_tracker hours company:api\n\
            time_tracker hours company:frontend\n\
            time_tracker hours company -s 2014-1-1\n\
            time_tracker hours company -s 2014-1-1 -e 2014-2-1\n\
            time_tracker hours -s 2014-1-1 -e 2014-2-1\n\n"
    end

    def get_start_date
      start_date = ARGV.shift
      abort 'Include start date with -s switch' if start_date.nil?
      start_date = start_date.split("-")
      Time.new(start_date[0], start_date[1], start_date[2])
    end

    def get_end_date
      end_date = ARGV.shift
      abort 'Include end date with -e switch' if end_date.nil?
      end_date = end_date.split("-")
      Time.new(end_date[0], end_date[1], end_date[2])
    end

    def print_projects(hours)
      total_hours = hours[:total]
      hours.delete :total
      hours.each do |project, tasks|
        project_hours = print_tasks(project, tasks)
        if project_hours > 0
          puts "  total:                    #{project_hours.round(2)} hours\n\n"
        end
      end
      puts "All Projects and tasks\ntotal: #{total_hours.round(2)}"
    end

    def print_tasks(project, tasks)
      project_hours = 0
      first = true
      tasks.each do |task, description|
        project_hours += print_task(project, task, description, first)
        first = false
      end
      project_hours
    end

    def print_task(project, task, description, first)
      total = description[:total]
      description.delete :total
      if description.size > 0
        if first
          puts "Project: #{project}"
        end
        puts "  Task: #{task}"
        description.each do |title, date|
          puts "    Description: #{title}"
          date.each do |day, hours|
            puts "      #{day}:           #{hours.round(2)} hours"
          end
        end
        puts "      total:                #{total.round(2)} hours"
        puts
      end
      total
    end
  end
end
