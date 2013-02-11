namespace :db do
  desc "Initialize annuity frequency types"
  task annuity: :environment do
    AnnuityFreqType.create(name: 'Daily')
    AnnuityFreqType.create(name: 'Weekly')
    AnnuityFreqType.create(name: 'Monthly')
    AnnuityFreqType.create(name: 'Quarterly')
    AnnuityFreqType.create(name: 'Yearly')
  end
end
