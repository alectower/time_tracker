module TimeTracker
  class WorkRange

    def self.hours(times, start_time, end_time)
      start_time = start_time || times.first
      end_time = end_time || times.last
      range = start_time..end_time

      daily_hours = daily(times, range)
      total_hours = total(daily_hours)

      {total_hours: total_hours, daily_hours: daily_hours}
    end

    private

    def self.daily(times, range)
      hours = {}
      in_time_range(times, range).each_slice(2) do |times|
        first, second = times
        date = first.to_date
        hours[date] = 0 unless hours[date]
        interval = diff_hours(first, second)
        hours[date] += interval
      end
      hours
    end

    def self.total(daily_hours)
      total = 0
      daily_hours.each do |k, v|
        rounded_time = nearest_quarter(v)
        daily_hours[k] = rounded_time
        total += rounded_time
      end
      total
    end

    def self.in_time_range(timestamps, range)
      timestamps.select { |l| range.cover?(l) }
    end

    def self.diff_hours(time_one, time_two)
      two = !time_two.nil? ? time_two : end_time(time_one)
      (two - time_one) / 3600.0
    end

    def self.nearest_quarter(num)
      (num * 4).ceil / 4.0
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
