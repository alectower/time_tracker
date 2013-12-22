require 'time_tracker/time'

module TimeTracker
  class Tracker

    TIME_FILE = "#{ENV['HOME']}/.time_tracker"

    attr_reader :file, :io

    private :file, :io

    def initialize(args = {})
      @io = args[:io] || File
      @file = args[:file] || TIME_FILE
    end

    def track
      io.open(file, 'a+') do |f|
        time = ::Time.now
        f.puts time
        f.rewind
        f.readlines.size % 2 != 0
      end
    end

    def empty
      io.truncate(file, 0)
    end

    def hours_tracked(days = nil)
      days =  days.nil? ? 1 : days.to_i
      hours = 0
      lines = in_time_range Time.range(days)
      lines.delete_at(-1) if lines.size % 2 != 0
      lines.each_slice(2) do |times|
        hours += Time.diff_hours(times[0], times[1])
      end
      hours
    end

    private

    def in_time_range(range)
      IO.readlines(file).map { |t|
        DateTime.parse(t.chomp).to_time
      }.select { |l| range.cover?(l) }
    end

  end
end
