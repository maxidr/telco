class LocalRate

  MINUTE_COST_RUSH_HOUR = 0.2
  MINUTE_COST_NORMAL_HOUR = 0.1

  def calculate(call)
    cost = rush_hour?(call.start) ? MINUTE_COST_RUSH_HOUR : MINUTE_COST_NORMAL_HOUR
    call.duration * cost
  end

  private

  def rush_hour?(time)
    return false if time.sunday? or time.saturday?
    time.hour >= 8 and (time.hour <= 19 and time.min <= 59)
  end
end

