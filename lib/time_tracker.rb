require 'optparse'
require_relative 'time_tracker/tracker'
require_relative 'time_tracker/reporter'

module TimeTracker
  def self.track(args)
    command = ARGV.shift
    case command
    when 'track'
      project_task = ARGV.shift
      project, task = project_task.split(":").map { |a| a.to_sym } if project_task
      abort 'missing required argument <project>' unless project && !project.empty?
      tracking = Tracker.track(project, task)
      if tracking % 2 != 0
        puts "on the clock"
      else
        puts "off the clock"
      end
    when 'hours'
      if ARGV.size % 2 != 0
        project_task = ARGV.shift
        project, task = project_task.split(":").map { |a| a.to_sym } if project_task
      end
      while arg = ARGV.shift
        case arg
        when /-s|--start/
          start_date = ARGV.shift
          if start_date.nil?
            puts "Include start date with -s switch"
            exit
          end
          start_date = start_date.split("-") if start_date
          start_date = Time.new(start_date[0], start_date[1], start_date[2]) if start_date
        when /-e|--end/
          end_date = ARGV.shift
          if end_date.nil?
            puts "Include end date with -e switch"
            exit
          end
          end_date  = end_date.split("-") if end_date
          end_date = Time.new(end_date[0], end_date[1], end_date[2]) if end_date
        end
      end
      projects = TimeTracker::Reporter.hours_tracked(project, task, start_date, end_date)
      total_hours = 0
      projects.each do |project, tasks|
        first = true
        tasks.each do |task, hours|
          if hours[:daily_hours].size > 0
            if first
              puts "Project: #{project}"
              first = false
            end
            puts "  Task: #{task}"
            hours[:daily_hours].sort.each do |date, hours|
              puts "    #{date}: #{hours} hours"
            end
            puts "    total:      #{hours[:total_hours]} hours"
            total_hours = (total_hours + hours[:total_hours]).round(3)
            puts
          end
        end
      end
      puts "All Projects and tasks\ntotal: #{total_hours}"
    else
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
            time_tracker hours company\n\n"
    end
  end
end
