module TimeTracker
  class WorkRange

    attr_reader :times, :start_time, :end_time, :range
    private :times, :start_time, :end_time, :range

    def initialize(args)
      @times = args[:times]
      @start_time = args[:start_time] || @times.first
      @end_time = args[:end_time] || @times.last
      @range = @start_time..@end_time
    end

    def hours
      daily = daily_hours
      {total_hours: total(daily), daily_hours: daily}
    end

    private

    def daily_hours
      hours = {}
      in_time_range.each_slice(2) do |t|
        first, second = t
        date = first.to_date
        hours[date] = 0 unless hours[date]
        interval = diff_hours(first, second)
        hours[date] += interval
      end
      hours
    end

    def total(daily)
      total = 0
      daily.each do |k, v|
        rounded_time = nearest_quarter(v)
        daily_hours[k] = rounded_time
        total += rounded_time
      end
      total
    end

    def in_time_range
      times.select { |l| range.cover?(l) }
    end

    def diff_hours(time_one, time_two)
      two = !time_two.nil? ? time_two : end_time(time_one)
      (two - time_one) / 3600.0
    end

    def nearest_quarter(num)
      (num * 4).ceil / 4.0
    end

    def end_time(time)
      if time.to_date == Date.today
        Time.now
      else
        Time.new(time.year, time.mon, time.day + 1)
      end
    end
  end
end
