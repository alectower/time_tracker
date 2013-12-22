require 'date'

module TimeTracker
  module Time

    def self.range(days)
      time = ::Time.now
      ::Time.at(time - to_seconds(days))..time
    end

    def self.to_seconds(days)
      days * 24 * 3600
    end

    def self.diff_hours(time_one, time_two)
      ((time_two - time_one) / 3600).round(2)
    end
  end
end
