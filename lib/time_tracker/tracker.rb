require_relative 'work_range'
require 'date'

module TimeTracker
  class Tracker

    TIME_DIR = "#{ENV['HOME']}/.hours"

    attr_reader :file

    private :file

    def initialize(file)
      Dir.mkdir(TIME_DIR) unless Dir.exists? TIME_DIR
      @file = "#{TIME_DIR}/#{file}"
    end

    def track
      File.open(file, 'a+') do |f|
        time = ::Time.now
        f.puts time
        f.rewind
        f.readlines.size % 2 != 0
      end
    end

    def empty
      File.truncate(file, 0)
    end

    def hours_tracked(start_date, end_date)
      TimeTracker::WorkRange.new(timestamps, start_date, end_date).hours
    end

    def timestamps
      IO.readlines(file).map do |t|
        ::DateTime.parse(t.chomp).to_time
      end
    end
  end
end
