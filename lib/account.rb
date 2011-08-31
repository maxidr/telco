class Account

  attr_reader :calls

  def initialize
    @calls = []
  end

  def register_call(call)
    @calls << call
  end

  def bill
    @calls.reduce { |memo, call| memo + Rates.calculate(call) }
  end

end

