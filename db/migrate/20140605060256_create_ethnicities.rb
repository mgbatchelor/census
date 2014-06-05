class CreateEthnicities < ActiveRecord::Migration
  def change
    create_table :ethnicities do |t|
      t.text :placename
      t.integer :sumlevid
      t.float :pct_hisp
      t.float :pct_non_hisp_white
      t.float :diversity_index
      t.text :location
      t.integer :fips
      t.integer :gnis

      t.timestamps
    end
  end
end
