require 'optparse'
require_relative 'time_tracker/config'
require_relative 'time_tracker/tracker'
require_relative 'time_tracker/reporter'
require_relative 'time_tracker/work_range'

module TimeTracker
  class CLI
    attr_reader :config

    def initialize
      @config = Config.new
    end

    def process
      command = ARGV.shift
      case command
      when 'track'
        track_time
      when 'hours'
        print_hours
      else
        print_options
      end
    end

    def track_time
      project_task = ARGV.shift
      project, task = project_task.split(":").
        map { |a| a.to_sym } if project_task
      abort 'missing required argument <project>' unless
        project && !project.empty?
      timestamps = Tracker.new(project: project, task: task).
        track
      tracking = timestamps.size % 2 != 0
      if tracking
        puts "on the clock"
      else
        puts "off the clock"
      end
      event = tracking ? :tracking_on : :tracking_off
      hours = WorkRange.new(times: timestamps).
        hours[:total_hours]
      config.sync event: event, project: project.to_s,
        task: task.to_s, hours: hours
    end

    def print_hours
      if ARGV.size > 1 && ARGV.size % 2 != 0
        project_task = ARGV.shift
        project, task = project_task.split(":").
          map { |a| a.to_sym } if project_task
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
        project: project, task: task,
        start_date: start_date,
        end_date: end_date
      ).hours_tracked
      print_project_task_hours(project_hours)
    end

    def print_options
      puts "\n\tUsage: time_tracker <command> [project]:[task] [OPTIONS]\n\n\
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

    def print_project_task_hours(projects)
      total_hours = 0
      projects.each do |project, tasks|
        first = true
        project_hours = 0
        tasks.each do |task, hours|
          if hours[:daily_hours].size > 0
            if first
              puts "Project: #{project}"
              first = false
            end
            puts "  Task: #{task}"
            hours[:daily_hours].sort.each do |date, hours|
              puts "    #{date}:           #{hours.round(2)} hours"
            end
            puts "    total (rounded):      #{hours[:total_hours]} hours"
            project_hours = (project_hours + hours[:total_hours]).round(2)
            total_hours = (total_hours + hours[:total_hours]).round(2)
            puts
          end
        end
        if project_hours > 0
          puts "  total (rounded):        #{project_hours} hours\n\n"
        end
      end
      puts "All Projects and tasks\ntotal: #{total_hours}"
    end
  end
end
