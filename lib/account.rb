require 'rate'

class Account

  attr_reader :calls

  def initialize
    @calls = []
  end

  def register_call(call)
    @calls << call
  end

  def bill(month = Time.now.month, year = Time.now.year)
    @calls.reduce(Rate::BASE_PAYMENT) do |memo, call|
      if (call.start.year == year && call.start.month == month)
        memo + Rate.calculate(call)
      else
        memo
      end
    end
  end



end

