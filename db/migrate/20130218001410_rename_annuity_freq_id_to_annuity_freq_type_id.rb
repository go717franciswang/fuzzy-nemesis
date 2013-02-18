class RenameAnnuityFreqIdToAnnuityFreqTypeId < ActiveRecord::Migration
  def change
    rename_column :simulations, :annuity_freq_id, :annuity_freq_type_id
  end
end
