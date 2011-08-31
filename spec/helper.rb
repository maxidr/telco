module Helper

  def hour(hour)
    Time.new(2011, 8, 1, hour)
  end

  def week_day_at(hour)
    Time.new(2011, 8, 1, hour)
  end

  def sunday_at(hour)
    Time.new(2011, 8, 7, hour)
  end

  def saturday_at(hour)
    Time.new(2011, 8, 6, hour)
  end

  def weekend_day(wday)
    return sunday_at(9) if wday == :sunday
    return saturday_at(9) if wday == :saturday
    nil
  end

  # opts:
  #   day: sunday or saturday
  #   zone: a Zone constant
  #   start_time: a time object
  def build_call(minutes, opts = {})
    start_time = [opts[:start_time], weekend_day(opts[:day]), Time.new(2011, 8, 2)].compact.first
#    start_time = opts[:start_time] ? opts[:start_time] : Time.new(2011, 8, 2)
#    start_time = weekend_day(opts[:day]) if opts[:day]
    end_time = start_time + 60 * minutes
    Call.new(:start => start_time, :end => end_time, :zone => opts[:zone])
  end
end

