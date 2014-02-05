module TimeTracker
  class WorkRange

    def self.hours(times, start_time, end_time)
      start_time = start_time || times.first
      end_time = end_time || times.last
      range = start_time..end_time

      total_hours = 0
      daily_hours = {}
      in_time_range(times, range).each_slice(2) do |times|
        first, second = times
        date = first.to_date
        daily_hours[date] = 0 unless daily_hours[date]
        interval = nearest_point_five diff_hours(first, second)
        total_hours = (total_hours + interval).round(3)
        daily_hours[date] = (daily_hours[date] + interval).round(3)
      end
      {total_hours: total_hours, daily_hours: daily_hours}
    end

    private

    def self.in_time_range(timestamps, range)
      timestamps.select { |l| range.cover?(l) }
    end

    def self.diff_hours(time_one, time_two)
      two = !time_two.nil? ? time_two : end_time(time_one)
      Rational(two - time_one, 3600.0)
    end

    def self.nearest_point_five(num)
      (num * 20).round / 20.0
    end

    def self.end_time(time)
      if time.to_date == Date.today
        Time.now
      else
        Time.new(time.year, time.mon, time.day + 1)
      end
    end
  end
end
