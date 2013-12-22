require_relative 'time_tracker/tracker'

module TimeTracker
  def self.track(args)
    case args[0]
    when 'track'
      tracking = TimeTracker::Tracker.new(file: args[1]).track
      if tracking
        puts "on the clock"
      else
        puts "off the clock"
      end
    when 'empty'
      TimeTracker::Tracker.new(file: args[1]).empty
    when 'hours'
      days = args[1]
      file = args[2]
      if file && days
        hours = TimeTracker::Tracker.new(file: file).hours_tracked(days)
      elsif days
        if days =~ /\d+/
          hours = TimeTracker::Tracker.new.hours_tracked(days)
        else
          file = days
          hours = TimeTracker::Tracker.new(file: file).hours_tracked
        end
      else
        hours = TimeTracker::Tracker.new.hours_tracked
      end
      puts "#{hours} hours"
    else
      puts "\n\tUsage: time_tracker [options]\n\n\
            Options:\n\n\
            track [file]         track time in file \n\
            empty [file]         empty tracked time\n\
            hours [n] [file]     print hours tracked for past n days\n\n"
    end
  end
end
