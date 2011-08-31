require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'helper'

include Helper


# a = Account.new
# a.register_call(call)
# a.bill                              -> current month bill
# a.bill(:month => 4, :year => 2011)  -> bill for april
# a.bill(:zone => Zone::LOCAL)        -> Bill for current month and local type
describe Account do

  def rate_for(start_time, zone, spec_rate)
    context "for a #{zone} call at #{start_time.hour}" do
      before { @call = Call.new(:start => start_time, :end => start_time + 60, :zone => zone) }
      it { Rate.calculate(@call).should == spec_rate }
    end
  end

  def load_calls
    calls = []
    calls << build_call(1, :start_time => hour(9)) << # 0.20
      build_call(5, :start_time => hour(7)) <<        # 5 * 0.10: 0.5
      build_call(1, :start_time => hour(21)) <<       # 0.10
      build_call(1, :day => :sunday) <<               # 0.10
      build_call(1, :day => :saturday) <<             # 0.10
      build_call(1, :zone => Zone::NATIONAL) <<       # 0.30
      build_call(1, :zone => Zone::SOUTH_AMERICA) <<  # 0.5
      build_call(1, :zone => Zone::NORTH_AMERICA) <<  # 0.7
      build_call(1, :zone => Zone::EUROPE) <<         # 0.7
      build_call(1, :zone => Zone::ELSEWHERE)         # 0.7  => total: 3.9
  end

  describe "#new" do
    subject { Account.new }
    its(:calls) { should be_empty }
    it { subject.bill(8,2011).should equal Rate::BASE_PAYMENT }
#    its(:bill) { should equal Rate::BASE_PAYMENT }

    describe "#register_call" do
      before do
        @account = Account.new
        @account.register_call Call.new(:start => Time.now - 120, :end => Time.now)
      end
      subject { @account }
      its(:calls) { should have(1).items }
      it { subject.bill(8, 2011).should  > Rate::BASE_PAYMENT }
#      its(:bill) { should > Rate::BASE_PAYMENT }
    end
  end

  describe "#bill" do

    describe 'when register a new call' do
      subject { Account.new }

      it 'of 1 minute local at 9 pm should bill 10.2 (10 + 0.2)' do
        subject.register_call build_call(1, :start_time => hour(9))
        subject.bill(8, 2011).should == 10.2
      end

      it 'of 5 minutes as local call at 10 pm should bill 11.0' do
        subject.register_call build_call(5, :start_time => hour(10))
        subject.bill(8, 2011).should == 11.0
      end

      it 'of 1 minutes as local call at 21 should bill 10.1' do
        subject.register_call build_call(1, :start_time => hour(21))
        subject.bill(8, 2011).should == 10.1
      end

      it 'of 1 minutes as local call at 7 am should bill 10.1' do
        subject.register_call build_call(1, :start_time => hour(7))
        subject.bill(8, 2011).should == 10.1
      end

    end


    describe "when register calls" do
      before do
        @account = Account.new
        load_calls().each { |c| @account.register_call c  }
      end

      it "should calculate the bill of the current month" do
        @account.bill(8, 2011) == Rate::BASE_PAYMENT + 3.9
      end
    end

    context "register calls for June, July and August" do
      before do
        calls = []
        calls <<
          build_call(10, :start_time => hour(7)) <<
          build_call(2, :start_time => Time.new(2011, 7, 2, 10), :zone => Zone::NATIONAL) <<
          build_call(1, :start_time => Time.new(2011, 6, 2, 10), :zone => Zone::ELSEWHERE)
        @account = Account.new
        calls.each { |c| @account.register_call c }
      end

      it "should calculate bill from August" do
        @account.bill(8, 2011).should == Rate::BASE_PAYMENT + 10 * 0.1
      end

      it "should calculate bill from July" do
        @account.bill(7, 2011).should == Rate::BASE_PAYMENT + 2 * 0.3
      end

      it "should calculate bill from June" do
        @account.bill(6, 2011).should == Rate::BASE_PAYMENT + 1.5
      end
    end
  end
end

