class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :nombre
      t.string :sector
      t.references :comuna, index: true

      t.timestamps null: false
    end
    add_foreign_key :sectors, :comunas
  end
end
