class FavoritesController < ApplicationController
  before_action :require_authentication

  def index
    @favorites = current_user.favorite_recipes.includes(:ingredients, :user)
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.favorites.find_or_create_by(recipe: recipe)
    redirect_back(fallback_location: root_path, notice: 'Recipe saved to favorites.')
  end

  def destroy
    favorite = current_user.favorites.find_by(recipe_id: params[:recipe_id])
    favorite&.destroy
    redirect_back(fallback_location: root_path, notice: 'Recipe removed from favorites.')
  end
end
