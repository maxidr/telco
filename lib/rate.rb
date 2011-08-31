require 'zone'

module Rate

  COST_BY_ZONE = {
    Zone::NATIONAL      => 0.3,
    Zone::SOUTH_AMERICA => 0.5,
    Zone::NORTH_AMERICA => 0.7,
    Zone::EUROPE        => 0.7,
    Zone::ELSEWHERE     => 1.5
  }

  #  Perform the cost calculation of a call using the COST_BY_ZONE hash.
  #  If you need to realize a particular calculation create a class (#{zone_name}Rate.rb)
  #  and implement the method calculate(call)
  def self.calculate(call)
    class_name = "#{call.zone.to_s.capitalize}Rate"
    return COST_BY_ZONE[call.zone] * call.duration unless Object.const_defined? class_name
    Object.const_get(class_name).new.calculate(call)
  end

end

