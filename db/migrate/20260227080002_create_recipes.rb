class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description
      t.integer :prep_time, null: false
      t.string :diet_type, null: false
      t.text :instructions, null: false
      t.string :visibility, null: false, default: 'public'
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end

    add_index :recipes, :visibility
    add_index :recipes, :diet_type
  end
end
