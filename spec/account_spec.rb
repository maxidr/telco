require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'account'
require 'call'

# a = Account.new
# a.register_call(call)
# a.bill                              -> current month bill
# a.bill(:month => 4, :year => 2011)  -> bill for april
# a.bill(:zone => Zone::LOCAL)        -> Bill for current month and local type
describe Account do

  describe "#register_call" do
     context "for a new account when register a valid call" do

      before do
        @account = Account.new
        @account.register_call Call.new(:start => Time.now - 120, :end => Time.now)
      end

      subject { @account }
      its(:calls) { should have(1).items }
    end

  end

  describe "#bill" do
    before { @account = Account.new }
    context 'when register a 1 minute local call inner 8 and 20 hours' do
      before { @account.register_call Call.new(:start => Time.now - (60 * 60), :end => Time.now) }
      subject { @account }
      it 'increment bill amount in $0.2' do
        @account.bill.should == 0.2
      end
    end

    context 'when register a 1 minute local call inner 0 and 8 hours or 20 and 0 hours' do
      it 'increment bill amount in $0.1' do
        pending
      end
    end

    context 'when register a one minute national call' do
      it 'increment bill amount in $0.3' do
        pending
      end
    end

    context 'when register a one minute call to south american number' do
      it 'increment bill amount in $0.5' do
        pending
      end
    end

    context 'when register a one minute call to south north number' do
      it 'increment bill amount in $0.7' do
        pending
      end
    end

    context 'when register a one minute call to europe number' do
      it 'increment bill amount in $0.7' do
        pending
      end
    end

    context 'when register a one minute call to a phone number elsewhere of the world' do
      it 'increment bill amount in $1.5' do
        pending
      end
    end

  end

#  shared_examples "a correct client account" do |account, number|
#    subject { account }
#    it { should_not be_nil }
#    its(:number) { should == number }
#  end

#  it_behaves_like "a correct client account", Account.new("32212037"), "32212037"
#  it_behaves_like "a correct client account", Account.find("32212037"), "32212037"

end

