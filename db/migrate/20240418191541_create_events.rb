class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.integer :min_qtd
      t.integer :max_qtd
      t.integer :duration
      t.string :menu
      t.boolean :drinks
      t.boolean :decoration
      t.boolean :valet
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
