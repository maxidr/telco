require 'spec_helper'
require 'helper'

include Helper

def rate_for(start_time, zone, spec_rate)
  context "for a #{zone} call at #{start_time.hour}" do
    before { @call = Call.new(:start => start_time, :end => start_time + 60, :zone => zone) }
    it { Rate.calculate(@call).should == spec_rate }
  end
end

def rate_for_weekend_day(wday, spec_rate)

  context "for a local call in #{wday}" do
    before do
      start_time = weekend_day(wday)
      @call = Call.new(:start => start_time, :end => start_time + 60)
    end
    it { Rate.calculate(@call).should == spec_rate }
  end
end

describe Rate do
  describe "#calculate a minute" do
    rate_for hour(9), Zone::LOCAL, 0.2
    rate_for hour(7), Zone::LOCAL, 0.1
    rate_for hour(21), Zone::LOCAL, 0.1
    rate_for hour(20), Zone::LOCAL, 0.1
    rate_for_weekend_day :saturday, 0.1
    rate_for_weekend_day :sunday, 0.1

    rate_for hour(9), Zone::NATIONAL, 0.3

    rate_for hour(9), Zone::SOUTH_AMERICA, 0.5
    rate_for hour(9), Zone::NORTH_AMERICA, 0.7
    rate_for hour(9), Zone::EUROPE, 0.7
    rate_for hour(9), Zone::ELSEWHERE, 1.5
  end
end

