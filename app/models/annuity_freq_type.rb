class AnnuityFreqType < ActiveRecord::Base
  attr_accessible :name

  def localize_name
    case self.name.to_sym
    when :Daily
      I18n.t 'simulation.funit.daily'
    when :Weekly
      I18n.t 'simulation.funit.weekly'
    when :Monthly
      I18n.t 'simulation.funit.monthly'
    when :Quarterly
      I18n.t 'simulation.funit.quarterly'
    when :Yearly
      I18n.t 'simulation.funit.yearly'
    end
  end
end
