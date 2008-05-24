class CreateMallineTests < ActiveRecord::Migration
  def self.up
    create_table :malline_tests do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :malline_tests
  end
end
