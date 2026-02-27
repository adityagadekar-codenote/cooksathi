Here is your **PRD.md** file content. You can copy this directly into `PRD.md` and feed it to your CLI agent.

---

# Cooksathi – Product Requirements Document (PRD)

## Product Name

**Cooksathi**

## Tagline

Your kitchen companion.

---

# 1. Objective

Build a web application using:

* Ruby on Rails- Version 8.1
* Ruby- 4.0
* PostgreSQL
* Tailwind CSS

The app allows users to:

1. Enter ingredients they currently have
2. Select diet type (Veg or Vegan)
3. Enter available cooking time (in minutes)
4. Receive ranked recipe suggestions based on match percentage

This is an MVP that must be simple, clean, and fully functional.

---

# 2. MVP Scope

## Included

* Ingredient-based recipe search
* Diet filter (Veg / Vegan)
* Maximum prep time filter
* Ranked results by match percentage
* Recipe detail page
* Seeded sample recipes
* Responsive UI with Tailwind CSS

## Not Included

* Authentication
* Favorites
* Admin dashboard
* Image uploads
* AI integrations
* Nutrition data
* Grocery list generation

---

# 3. Core User Flow

## 3.1 Homepage

User sees:

* Text input for ingredients (comma separated)
* Dropdown for diet type (Veg / Vegan)
* Numeric input for maximum time (minutes)
* Submit button

On submit → POST to `/search`

---

## 3.2 Results Page

Display list of recipes sorted by:

1. Highest match percentage
2. Lowest missing ingredient count
3. Lowest prep time

Each result card shows:

* Recipe name
* Prep time
* Match percentage
* Missing ingredient count
* Button to view recipe

If no recipes match → show friendly empty state message.

---

## 3.3 Recipe Detail Page

Display:

* Recipe name
* Prep time
* Diet type
* Full ingredient list
* Missing ingredients (highlighted)
* Step-by-step instructions

---

# 4. Functional Requirements

## 4.1 Ingredient Input Processing

* Input format: comma separated string
* Normalize:

  * Convert to lowercase
  * Strip whitespace
  * Remove duplicates
* Convert into array of ingredient names

---

## 4.2 Recipe Filtering Logic

### Step 1: Base Filtering

Filter recipes where:

* `diet_type == selected_diet`
* `prep_time <= user_time`

### Step 2: Matching Score

For each filtered recipe:

* matched_ingredients = intersection of recipe ingredients and user ingredients
* total_recipe_ingredients = total ingredients in recipe

match_percentage =
(matched_ingredients / total_recipe_ingredients) * 100

Only include recipes where:

* match_percentage >= 40

### Step 3: Missing Ingredients

missing_ingredients =
recipe ingredients - user ingredients

---

## 4.3 Sorting Logic

Sort by:

1. match_percentage DESC
2. missing_ingredients count ASC
3. prep_time ASC

---

# 5. Database Schema

## recipes

* id (integer, primary key)
* name (string, required)
* description (text)
* prep_time (integer, required)
* diet_type (string, required: "veg" or "vegan")
* instructions (text, required)
* created_at
* updated_at

---

## ingredients

* id (integer, primary key)
* name (string, required, unique)
* created_at
* updated_at

Add unique index on `name`.

---

## recipe_ingredients

* id (integer, primary key)
* recipe_id (integer, foreign key)
* ingredient_id (integer, foreign key)
* created_at
* updated_at

Add indexes on:

* recipe_id
* ingredient_id

---

# 6. Associations

Recipe:

* has_many :recipe_ingredients
* has_many :ingredients, through: :recipe_ingredients

Ingredient:

* has_many :recipe_ingredients
* has_many :recipes, through: :recipe_ingredients

RecipeIngredient:

* belongs_to :recipe
* belongs_to :ingredient

---

# 7. Routes

* GET `/` → home#index
* POST `/search` → recipes#search
* GET `/recipes/:id` → recipes#show

No other routes required.

---

# 8. Controllers

## HomeController

* index

## RecipesController

### search

Responsibilities:

* Parse and normalize user ingredients
* Filter recipes by diet and prep_time
* Calculate match percentage
* Calculate missing ingredients
* Sort results
* Return ranked list to view

### show

* Display full recipe details

---

# 9. Seed Data Requirements

Seed at least 10 recipes.

Each recipe must:

* Have 4–8 ingredients
* Have overlapping ingredients with other recipes
* Include a mix of Veg and Vegan recipes
* Have realistic prep times (10–45 minutes)
* Include complete instructions

Ensure good ingredient reuse so matching works meaningfully.

---

# 10. UI Requirements (Tailwind CSS)

## General

* Clean, minimal layout
* Centered container
* Responsive design
* Green primary button theme

---

## Homepage UI

* Large title: Cooksathi
* Ingredients input (full width)
* Diet dropdown
* Time input
* Submit button
* Basic validation message for empty ingredients

---

## Results Page

* Grid or vertical card layout
* Each card:

  * Recipe name (bold)
  * Prep time
  * Match %
  * Missing count
  * View button

---

## Recipe Detail Page

Sections:

* Header with name
* Meta info (prep time, diet)
* Ingredient list
* Missing ingredients in red
* Instructions in numbered list

---

# 11. Edge Cases

* Empty ingredient input → validation error
* Non-numeric time → validation error
* No matching recipes → friendly message
* Duplicate ingredients → remove before processing
* Case-insensitive matching

---

# 12. Non-Functional Requirements

* No N+1 queries (use includes)
* Fast response time locally
* Clean and readable code
* Proper model validations
* No runtime errors on bad input

---

# 13. Acceptance Criteria

The feature is considered complete when:

* User can search using ingredients, diet, and time
* Recipes are ranked correctly
* Match percentage is accurate
* Missing ingredients are displayed
* Detail page works correctly
* Seeds load successfully
* UI is responsive
* No crashes on invalid input

---

# 14. Definition of Done

* Database schema implemented
* Associations working
* Search logic implemented
* Seeds populated
* UI complete
* Manual testing performed
* Application runs without errors

---

# 15. Future Enhancements (Out of Scope)

* Authentication
* Save favorites
* Grocery list generator
* AI-powered suggestions
* Nutrition API integration
* Admin dashboard
* Image uploads
* Public deployment

---
