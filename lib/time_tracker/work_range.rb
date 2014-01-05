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
      total_hours = 0
      daily_hours = {}
      in_time_range.each_slice(2) do |times|
        first, second = times
        date = first.to_date
        daily_hours[date] = 0 unless daily_hours[date]
        interval = diff_hours(first, second)
        total_hours += interval
        daily_hours[date] += interval
      end
      {total_hours: total_hours.to_f.round(2), daily_hours: daily_hours}
    end

    private

    def in_time_range
      timestamps.select { |l| range.cover?(l) }
    end

    def diff_hours(time_one, time_two)
      two = !time_two.nil? ? time_two : end_time(time_one)
      Rational(two - time_one, 3600.0)
    end

    def end_time(time)
      if time.to_date == Date.today
        ::Time.now
      else
        ::Time.new(time.year, time.mon, time.day + 1)
      end
    end
  end
end
