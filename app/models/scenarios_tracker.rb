class ScenariosTracker
  def initialize(scenarios, start_date)
    @frequencies = {}
    @frequency_types = {}
    @next_new_valid_action_date = {}

    scenarios.each do |scenario|
      id = scenario[:id]
      @frequencies[id] = scenario[:frequency]
      @frequency_types[id] = scenario[:frequency_type].to_sym
      @next_new_valid_action_date[id] = start_date
    end
  end

  def act_on(scenario, date_at)
    id = scenario[:id]
    times = @frequencies[id]
    while @next_new_valid_action_date[id] <= date_at
      puts "times: #{times}"
      puts "next date: #{@next_new_valid_action_date[id]}"
      @next_new_valid_action_date[id] = (
        case @frequency_types[id]
        when :Days
          @next_new_valid_action_date[id].next_day(times)
        when :Weeks
          @next_new_valid_action_date[id].next_day(times * 7)
        when :Months
          @next_new_valid_action_date[id].next_month(times)
        when :Quarters
          @next_new_valid_action_date[id].next_month(times * 3)
        when :Years
          @next_new_valid_action_date[id].next_year(times)
        end
      )
    end
  end

  def time_to_act_on?(scenario, date_at)
    id = scenario[:id]
    @next_new_valid_action_date[id] <= date_at
  end
end
