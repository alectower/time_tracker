require 'spec_helper'
require_relative '../lib/time_tracker/work_range'

describe TimeTracker::WorkRange do

  let(:timestamps) {[
    Time.new(2014, 1, 1, 8, 0, 0, "-05:00"),
    Time.new(2014, 1, 1, 9, 0, 0, "-05:00"),
    Time.new(2014, 1, 2, 14, 0, 0, "-05:00"),
  ]}
  let(:start_time) { Time.new(2013, 12, 31) }
  let(:end_time) { Time.new(2014, 1, 2) }
  let (:file) { double("file") }

  it 'calculates hours with start and end time' do
    TimeTracker::WorkRange.new(timestamps, start_time, end_time).hours.should eq 1.00
  end

  it 'calculates hours with start time and default end time' do
    TimeTracker::WorkRange.new(timestamps, start_time, nil).hours.should eq 11.00
  end

  it 'calculates hours with default start time and end time' do
    TimeTracker::WorkRange.new(timestamps, nil, end_time).hours.should eq 1.00
  end

  it 'calculates hours with default start and default end time' do
    TimeTracker::WorkRange.new(timestamps, nil, nil).hours.should eq 11.00
  end
end
