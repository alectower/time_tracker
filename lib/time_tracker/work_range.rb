module TimeTracker
  class WorkRange

    attr_reader :file, :range, :timestamps

    private :file, :range, :timestamps

    def initialize(timestamps, start_time, end_time)
      @timestamps = timestamps
      start_time = start_time || timestamps.first
      end_time = end_time || timestamps.last
      @range = start_time..end_time
    end

    def hours
      hours = 0
      in_time_range.each_slice(2) do |times|
        hours += diff_hours(times[0], times[1])
      end
      hours
    end

    private

    def in_time_range
      timestamps.select { |l| range.cover?(l) }
    end

    def diff_hours(time_one, time_two)
      two = !time_two.nil? ? time_two : tomorrow(time_one)
      ((two - time_one) / 3600.0).round(2)
    end

    def tomorrow(time)
      ::Time.new(time.year, time.mon, time.day + 1)
    end
  end
end
