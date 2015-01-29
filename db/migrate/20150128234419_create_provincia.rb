class CreateProvincia < ActiveRecord::Migration
  def change
    create_table :provincia do |t|
      t.string :nombre
      t.references :region, index: true

      t.timestamps null: false
    end
    add_foreign_key :provincia, :regions
  end
end
