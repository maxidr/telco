class Call

  attr_reader :start, :end, :zone

  def initialize(args)
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    validate
    @zone = Zone::LOCAL if @zone.nil?
  end

  def duration
    ((@end - @start) / 60).round
  end

  private

  def validate
    raise ArgumentError, 'start time and end time is required' if @start.nil? or @end.nil?
    raise ArgumentError, 'start time is not a Time object' unless @start.is_a? Time
    raise ArgumentError, 'end time is not a Time object' unless @end.is_a? Time
    raise ArgumentError, 'start time cannot be later than end time' if @start > @end
  end
end


#call = Call.new(Date.now, Date.now + 1.hours, Zone::Sudamerica)
#client_account = Account.client('32212037')
#client_account.register_call(call)
#client_account.calculate_bill()
#client_account.bill(4, 2011)
#client_account.bill(:zone => Zone::Sudamerica)
#client_account.register_call(:start => Date.now, :end => Date.now + 1.hours, :zone => Zone::Sudamerica)

