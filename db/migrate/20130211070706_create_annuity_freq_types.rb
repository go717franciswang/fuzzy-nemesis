class CreateAnnuityFreqTypes < ActiveRecord::Migration
  def change
    create_table :annuity_freq_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
