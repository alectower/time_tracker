require 'spec_helper'
require_relative '../lib/time_tracker/time'

describe TimeTracker::Time do

  describe '.range' do
    it 'creates date span range given 1 day' do
      range_end = Time.new(2013, 1, 2)
      range_start = Time.new(2013, 1, 1)
      ::Time.stub(:now).and_return range_end
      TimeTracker::Time.range(1).
        should eql Range.new(range_start, range_end)
    end

    it 'creates date span range given multiple days' do
      range_end = Time.new(2013, 1, 5)
      range_start = Time.new(2013, 1, 1)
      ::Time.stub(:now).and_return range_end
      TimeTracker::Time.range(4).
        should eql Range.new(range_start, range_end)
    end
  end

  describe '.to_seconds' do
    it 'converts days to seconds' do
      TimeTracker::Time.to_seconds(1).should eql 86400
    end
  end

  describe '.hours' do
    it 'gets the difference in hours for minutes' do
      time_one = Time.new(2013, 12, 22, 9, 0, 0, "-05:00")
      time_two = Time.new(2013, 12, 22, 9, 10, 0, "-05:00")
      TimeTracker::Time.diff_hours(time_one, time_two).should eql 0.17
    end

    it 'gets the difference in hours for hours' do
      time_one = Time.new(2013, 12, 22, 9, 0, 0, "-05:00")
      time_two = Time.new(2013, 12, 22, 14, 0, 0, "-05:00")
      TimeTracker::Time.diff_hours(time_one, time_two).should eql 5.0
    end

    it 'gets the difference in hours and minutes for hours' do
      time_one = Time.new(2013, 12, 22, 9, 30, 0, "-05:00")
      time_two = Time.new(2013, 12, 22, 14, 0, 0, "-05:00")
      TimeTracker::Time.diff_hours(time_one, time_two).should eql 4.5
    end
  end
end
