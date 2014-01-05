require_relative 'time_tracker/tracker'

module TimeTracker
  def self.track(args)
    case args[0]
    when 'track'
      tracking = TimeTracker::Tracker.new(args[1]).track
      if tracking
        puts "on the clock"
      else
        puts "off the clock"
      end
    when 'empty'
      TimeTracker::Tracker.new(args[1]).empty
    when 'hours'
      file = args[1]
      start_date = args[2]
      start_date = start_date.split("-") if start_date
      start_date = Time.new(start_date[0], start_date[1], start_date[2]) if start_date
      end_date = args[3]
      end_date  = end_date.split("-") if end_date
      end_date = Time.new(end_date[0], end_date[1], end_date[2]) if end_date
      hours = TimeTracker::Tracker.new(file).hours_tracked(start_date, end_date)
      puts "#{hours} hours"
    else
      puts "\n\tUsage: time_tracker [options]\n\n\
            Options:\n\n\
            track [file]                             track time in file \n\
            empty [file]                             empty tracked time\n\
            hours [file] [start date] [end date]     print hours tracked for date range\n\n"
    end
  end
end
