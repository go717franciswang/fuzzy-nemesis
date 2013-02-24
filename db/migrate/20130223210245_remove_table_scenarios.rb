class RemoveTableScenarios < ActiveRecord::Migration
  def up
    drop_table :scenarios
  end

  def down
    create_table :scenarios do |t|
      t.string :name

      t.timestamps
    end
  end
end
