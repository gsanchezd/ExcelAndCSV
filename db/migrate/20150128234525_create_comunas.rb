class CreateComunas < ActiveRecord::Migration
  def change
    create_table :comunas do |t|
      t.string :nombre
      t.references :provincia, index: true

      t.timestamps null: false
    end
    add_foreign_key :comunas, :provincia
  end
end
