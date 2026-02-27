class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end

    # Unique constraint on (user_id, recipe_id)
    add_index :favorites, [:user_id, :recipe_id], unique: true, name: "index_favorites_on_user_id_and_recipe_id"
  end
end
