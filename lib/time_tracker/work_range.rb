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
      daily_hours = {}
      total_hours = 0
      in_time_range.each_slice(2) do |t|
        first, second = t
        date = first.to_date
        daily_hours[date] = 0 unless daily_hours[date]
        interval = diff_hours(first, second)
        daily_hours[date] += interval
        total_hours += interval
      end
      {
        total_hours: nearest_quarter(total_hours),
        daily_hours: daily_hours
      }
    end

    private

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
