require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'call'
require 'zone'

describe Call do
  now = Time.now
  start_time = now - (60 * 60)
  end_time = now
  context "build with star time #{start_time}, end time #{end_time} and local zone" do
    subject { Call.new(:start => start_time, :end => end_time, :zone => Zone::LOCAL) }
    it { should_not be_nil }
    its(:start) { should equal start_time }
    its(:end) { should equal end_time }
    its(:duration) { should equal 60 }
    its(:zone) { should equal Zone::LOCAL }
  end

  context "build without zone" do
    subject { Call.new(:start => start_time, :end => end_time) }
    its(:zone) { should equal Zone::LOCAL }
  end

  describe "#new should raise error" do
    it "without params" do
      expect { Call.new }.to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "without :start param" do
      expect { Call.new(:end => Time.now) }.to raise_error(ArgumentError, "start time and end time is required")
    end

    it "without :end param" do
      expect { Call.new(:start => Time.now) }.to raise_error(ArgumentError, "start time and end time is required")
    end

    it "if :start param is not Time object" do
      expect { Call.new(:start => 'today', :end => Time.now) }.to raise_error(ArgumentError, "start time is not a Time object")
    end

    it "if :end param is not Time object" do
      expect { Call.new(:end => 'today', :start => Time.now) }.to raise_error(ArgumentError, "end time is not a Time object")
    end

    it "if :start is mayor to :end" do
      expect { Call.new(:start => Time.now + 1, :end => Time.now) }.to raise_error(ArgumentError, "start time cannot be later than end time")
    end
  end

end

