require 'optparse'
require_relative 'time_tracker/tracker'

module TimeTracker
  def self.track(args)
    command = ARGV.shift
    file = ARGV.shift
    case command
    when 'track'
      puts "File must be included" if file.nil?
      tracking = TimeTracker::Tracker.new(file).track
      if tracking
        puts "on the clock"
      else
        puts "off the clock"
      end
    when 'empty'
      puts "File must be included" if file.nil?
      TimeTracker::Tracker.new(file).empty
    when 'hours'
      puts "File must be included" if file.nil?
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
      info = TimeTracker::Tracker.new(file).hours_tracked(start_date, end_date)
      info[:daily_hours].sort.each do |date, hours|
        puts "#{date}: #{hours.to_f.round(2)} hours"
      end
      puts "total:      #{info[:total_hours]} hours"
    else
      puts "\n\tUsage: time_tracker <command> <file> [OPTIONS]\n\n\
        Commands\n\
            track        track time in file (file will be placed in ~/.hours dir)\n\
            empty        empty tracked time\n\
            hours        print hours tracked for date range\n\

        Options\n\
            -s, --start <YYYY-MM-DD>    used with hours command
            -e, --end <YYYY-MM-DD>      used with hours command\n\n"
    end
  end
end
