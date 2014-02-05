require 'spec_helper'
require_relative '../lib/time_tracker/work_range'

module TimeTracker
  describe WorkRange do

    let(:timestamps) {[
      Time.parse("2014-01-01 08:00:00 -05:00"),
      Time.parse("2014-01-01-09:00:00 -05:00"),
      Time.parse("2014-01-02-14:00:00 -05:00"),
      Time.parse("2014-01-02-20:00:00 -05:00"),
      Time.parse("2014-01-03-08:00:00 -05:00"),
    ]}
    let(:start_time) { Time.new(2013, 12, 31) }
    let(:end_time) { Time.new(2014, 1, 2) }
    let(:first) { Date.new 2014, 01, 01}
    let(:second) { Date.new 2014, 01, 02}
    let(:third) { Date.new 2014, 01, 03}

    it 'calculates hours with start and end time' do
      hours = WorkRange.hours(timestamps, start_time, end_time)
      hours[:total_hours].should eq 1.00
      hours[:daily_hours][first].should eq 1.00
      hours[:daily_hours][second].should eq nil
      hours[:daily_hours][third].should eq nil
    end

    it 'calculates hours with start time and default end time' do
      hours = WorkRange.hours(timestamps, start_time, nil)
      hours[:total_hours].should eq 23.00
      hours[:daily_hours][first].should eq 1.00
      hours[:daily_hours][second].should eq 6.00
      hours[:daily_hours][third].should eq 16.00
    end

    it 'calculates hours with default start time and end time' do
      hours = WorkRange.hours(timestamps, nil, end_time)
      hours[:total_hours].should eq 1.00
      hours[:daily_hours][first].should eq 1.00
      hours[:daily_hours][second].should eq nil
      hours[:daily_hours][third].should eq nil
    end

    it 'calculates hours with default start and default end time' do
      hours = WorkRange.hours(timestamps, nil, nil)
      hours[:total_hours].should eq 23.00
      hours[:daily_hours][first].should eq 1.00
      hours[:daily_hours][second].should eq 6.00
      hours[:daily_hours][third].should eq 16.00
    end
  end
end
