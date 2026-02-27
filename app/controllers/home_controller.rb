class HomeController < ApplicationController
  def index
    @trending_recipes = Recipe.includes(:ingredients).public_only.order(created_at: :desc).limit(6)
  end
end
