class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show edit update destroy]
  before_action :require_authentication, except: %i[search show]
  before_action :require_ownership, only: %i[edit update destroy]

  def search
    @ingredients_input = params[:ingredients] || ""
    @diet_type = params[:diet_type]
    @max_time = params[:max_time].to_i if params[:max_time].present?

    # Validate inputs
    @errors = []
    @errors << "Please enter at least one ingredient" if @ingredients_input.blank?
    @errors << "Please enter a valid time" if params[:max_time].present? && (@max_time.nil? || @max_time <= 0)

    if @errors.empty?
      # Parse and normalize user ingredients
      user_ingredients = parse_ingredients(@ingredients_input)

      # Find matching ingredient names (case-insensitive)
      matched_ingredient_names = Ingredient.where("LOWER(name) IN (?)", user_ingredients).pluck("LOWER(name)")

      # Base query with eager loading - only visible recipes
      recipes_query = Recipe.includes(:ingredients).visible_to(current_user)

      # Filter by diet type if provided and not empty
      if @diet_type.present? && @diet_type != ''
        recipes_query = recipes_query.where(diet_type: @diet_type)
      end

      # Filter by max time if provided
      recipes_query = recipes_query.where("prep_time <= ?", @max_time) if @max_time && @max_time > 0

      # Get all candidate recipes
      candidate_recipes = recipes_query.to_a

      # Filter recipes and calculate scores
      @recipes = candidate_recipes.select do |recipe|
        recipe_ingredient_names = recipe.ingredients.pluck("LOWER(name)")
        recipe.matched_count = (recipe_ingredient_names & matched_ingredient_names).size
        recipe.total_count = recipe.ingredients.count
        recipe.match_percentage = (recipe.matched_count.to_f / recipe.total_count * 100).round
        recipe.missing_count = recipe.total_count - recipe.matched_count

        recipe.match_percentage >= 20
      end

      # Sort by match_percentage DESC, missing_count ASC, prep_time ASC
      @recipes.sort_by! { |r| [-r.match_percentage, r.missing_count, r.prep_time] }
    else
      @recipes = []
    end

    render :search
  end

  def show
    @user_ingredients = params[:user_ingredients]&.split(",")&.map { |i| i.strip.downcase } || []

    @missing_ingredients = @recipe.ingredients.select do |ingredient|
      !@user_ingredients.include?(ingredient.name.downcase)
    end

    @matched_ingredients = @recipe.ingredients.select do |ingredient|
      @user_ingredients.include?(ingredient.name.downcase)
    end

    @is_favorite = current_user&.favorites&.exists?(recipe: @recipe)
  end

  def index
    @recipes = Recipe.includes(:ingredients).public_only
    
    # Apply filters
    if params[:diet_type].present?
      @recipes = @recipes.where(diet_type: params[:diet_type])
    end
    
    if params[:max_time].present?
      @recipes = @recipes.where("prep_time <= ?", params[:max_time].to_i)
    end
    
    if params[:visibility] == "private" && logged_in?
      @recipes = Recipe.includes(:ingredients).where(user_id: current_user.id, visibility: "private")
    end
    
    @recipes = @recipes.order(created_at: :desc)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      assign_ingredients(@recipe, params[:ingredients_list])
      redirect_to @recipe, notice: 'Recipe created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      @recipe.recipe_ingredients.destroy_all
      assign_ingredients(@recipe, params[:ingredients_list])
      redirect_to @recipe, notice: 'Recipe updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to root_path, notice: 'Recipe deleted successfully.'
  end

  private

  def set_recipe
    @recipe = Recipe.includes(:ingredients, :user).find(params[:id])
  end

  def require_ownership
    return if current_user == @recipe.user
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def recipe_params
    params.require(:recipe).permit(:name, :description, :prep_time, :diet_type, :instructions, :visibility)
  end

  def assign_ingredients(recipe, ingredients_list)
    return unless ingredients_list

    ingredient_names = parse_ingredients(ingredients_list)

    ingredient_names.each do |name|
      ingredient = Ingredient.find_or_create_by(name: name)
      recipe.ingredients << ingredient unless recipe.ingredients.include?(ingredient)
    end
  end

  def parse_ingredients(input)
    input.downcase
         .split(",")
         .map { |i| i.strip }
         .reject { |i| i.blank? }
         .uniq
  end
end
