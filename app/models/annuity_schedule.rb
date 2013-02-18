class AnnuitySchedule
  def initialize(start_date, frequency_type)
    @start_date = start_date
    @frequency_type = frequency_type
    @next_deposit_on = @start_date
  end

  def next_deposit_from(cur_date)
    case @frequency_type.name
    when 'Daily'
      return cur_date + 1
    when 'Weekly'
      return cur_date.next_week
    when 'Monthly'
      return cur_date.next_month
    when 'Quarterly'
      tmp_date = cur_date.dup
      3.times { tmp_date = tmp_date.next_month }
      return tmp_date
    when 'Yearly'
      return cur_date.next_year
    end
  end

  def next_deposit_date
    @next_deposit_on = self.next_deposit_from(@next_deposit_on)
  end
end
