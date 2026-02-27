
# Cooksathi – Product Requirements Document (PRD)

## Product Name

**Cooksathi**

## Tagline

Your kitchen companion.

---

# 1. Objective

Build a web application using:

* Ruby on Rails
* PostgreSQL
* Tailwind CSS

The application allows users to:

1. Search recipes using ingredients, diet type, and available time (no login required)
2. Sign up and log in
3. Save favorite recipes
4. Create their own recipes
5. Mark recipes as public or private
6. Dynamically add new ingredients when creating recipes
7. Browse public recipes created by all users

This is an MVP and must be clean, functional, and production-structured.

---

# 2. User Roles

## 2.1 Anonymous User

Can:

* Search recipes
* View public recipe details
* See public user-created recipes

Cannot:

* Save favorites
* Create recipes
* Edit/delete recipes
* View private recipes

---

## 2.2 Registered User

Can:

* Search recipes
* View all public recipes
* View own private recipes
* Save favorite recipes
* Create new recipes
* Edit/delete their own recipes
* Mark recipes as public or private
* Add new ingredients during recipe creation

Cannot:

* Edit/delete others' recipes
* View others’ private recipes

---

# 3. MVP Scope

## Included

* Ingredient-based search
* Diet filter (Veg / Vegan)
* Maximum prep time filter
* Ranked results by match %
* Authentication (Signup/Login/Logout)
* Favorites system
* Recipe CRUD for authenticated users
* Public/Private visibility
* Dynamic ingredient creation
* Seeded recipes
* Responsive UI

## Not Included

* Password reset
* Social login
* Comments
* Ratings
* Admin dashboard
* Image uploads
* AI suggestions
* Nutrition data

---

# 4. Core User Flows

---

## 4.1 Anonymous Search Flow

1. Visit homepage
2. Enter:

   * Ingredients (comma separated)
   * Diet type
   * Maximum time
3. Submit search
4. View ranked results
5. View recipe details (public only)

If clicking "Save to Favorites":

* Redirect to login page

---

## 4.2 Signup / Login Flow

User can:

* Sign up with:

  * Name
  * Email (unique)
  * Password
* Login
* Logout

After login:

* Redirect to homepage

Passwords must be securely hashed.

---

## 4.3 Favorites Flow

Authenticated user can:

* Click "Save to Favorites"
* Remove from favorites
* View favorites page

Rules:

* Cannot favorite same recipe twice
* Unique constraint on (user_id, recipe_id)

---

## 4.4 Recipe Creation Flow

Authenticated user can:

1. Click "Create Recipe"
2. Fill form:

   * Name
   * Description
   * Prep time
   * Diet type (veg/vegan)
   * Ingredients (comma separated input)
   * Instructions
   * Visibility (public/private)
3. Submit

System must:

* Normalize ingredient names
* Find existing ingredients OR create new ones
* Associate ingredients with recipe
* Save recipe with user_id

---

# 5. Ingredient Management

## 5.1 Ingredient Rules

Anonymous users:

* Cannot create ingredients
* Can search using existing ones

Registered users:

* Can introduce new ingredients during recipe creation/edit

New ingredients must:

* Be saved globally
* Be visible to all users
* Be usable in search immediately

---

## 5.2 Ingredient Normalization

When processing ingredient input:

1. Split by comma
2. Trim whitespace
3. Convert to lowercase
4. Remove duplicates
5. Reject blank values

---

## 5.3 Ingredient Uniqueness

Database must enforce:

* Case-insensitive uniqueness

Example:

"Tomato" and "tomato" must not both exist.

Add unique index on LOWER(name).

---

# 6. Recipe Visibility Rules

Each recipe must have:

* visibility (enum or string: "public", "private")
* user_id (nullable for seeded system recipes)

Visibility rules:

Public recipes:

* Visible to everyone

Private recipes:

* Visible only to owner

Search results must include:

* All public recipes
* Current user's private recipes (if logged in)

Search must exclude:

* Other users’ private recipes

---

# 7. Recipe Matching Logic

## Step 1: Base Filtering

Filter recipes where:

* diet_type matches selected diet
* prep_time <= user_time
* visibility rule is satisfied

---

## Step 2: Match Score Calculation

For each candidate recipe:

matched_ingredients = intersection of recipe.ingredients and user.ingredients

total_recipe_ingredients = recipe.ingredients.count

match_percentage =
(matched_ingredients / total_recipe_ingredients) * 100

Only include recipes where:

* match_percentage >= 40

---

## Step 3: Missing Ingredients

missing_ingredients =
recipe.ingredients - user.ingredients

---

## Step 4: Sorting

Sort results by:

1. match_percentage DESC
2. missing_ingredients count ASC
3. prep_time ASC

---

# 8. Database Schema

---

## users

* id
* name (required)
* email (required, unique)
* password_digest (required)
* created_at
* updated_at

---

## recipes

* id
* name (required)
* description
* prep_time (required)
* diet_type (required: veg/vegan)
* instructions (required)
* visibility (required: public/private)
* user_id (nullable for seeded recipes)
* created_at
* updated_at

---

## ingredients

* id
* name (required)
* created_at
* updated_at

Constraints:

* Unique index on lower(name)

---

## recipe_ingredients

* id
* recipe_id
* ingredient_id
* created_at
* updated_at

Indexes:

* recipe_id
* ingredient_id

---

## favorites

* id
* user_id
* recipe_id
* created_at

Constraints:

* Unique index on (user_id, recipe_id)

---

# 9. Associations

User:

* has_many :recipes
* has_many :favorites
* has_many :favorite_recipes, through: :favorites, source: :recipe

Recipe:

* belongs_to :user (optional)
* has_many :recipe_ingredients
* has_many :ingredients, through: :recipe_ingredients
* has_many :favorites

Ingredient:

* has_many :recipe_ingredients
* has_many :recipes, through: :recipe_ingredients

Favorite:

* belongs_to :user
* belongs_to :recipe

---

# 10. Routes

Public:

* GET `/`
* POST `/search`
* GET `/recipes/:id`
* GET `/signup`
* POST `/users`
* GET `/login`
* POST `/login`
* DELETE `/logout`

Authenticated:

* GET `/favorites`
* POST `/recipes/:id/favorite`
* DELETE `/recipes/:id/unfavorite`
* GET `/recipes/new`
* POST `/recipes`
* GET `/recipes/:id/edit`
* PATCH `/recipes/:id`
* DELETE `/recipes/:id`

---

# 11. Authorization Rules

Require authentication for:

* Creating recipe
* Editing recipe
* Deleting recipe
* Favoriting recipe
* Viewing favorites page

Enforce:

* Only owner can edit/delete recipe
* Only owner can view private recipe
* Anonymous users cannot access private recipes

Return:

* Redirect to login OR 403 for unauthorized access

---

# 12. Non-Functional Requirements

* No N+1 queries
* Model validations present
* DB-level constraints enforced
* Secure password hashing
* Clean Tailwind UI
* Responsive design
* Graceful error handling

---

# 13. Edge Cases

* Duplicate ingredients in input → deduplicate
* Ingredient case variations → normalized
* Simultaneous creation of same ingredient → unique index handles
* Anonymous trying to favorite → redirect to login
* Accessing others' private recipe → blocked
* Empty search input → validation error

---

# 14. Acceptance Criteria

Anonymous user:

* Can search recipes
* Can view public recipes
* Cannot access private recipes
* Cannot favorite recipes

Registered user:

* Can signup/login/logout
* Can create recipe
* Can mark public/private
* Can dynamically add new ingredients
* Can favorite/unfavorite recipes
* Can view favorites page
* Can edit/delete own recipes
* Cannot edit/delete others’ recipes

System:

* Ingredients created dynamically are globally visible
* No duplicate ingredient records
* Visibility rules strictly enforced
* Search respects visibility
* Ranking logic works correctly
* Database constraints prevent invalid states
* Application runs without errors

---

# 15. Definition of Done

* Authentication implemented
* Favorites implemented
* Recipe CRUD implemented
* Public/private visibility enforced
* Dynamic ingredient creation implemented
* Case-insensitive ingredient uniqueness enforced
* Search ranking logic implemented
* Seed data added
* Manual testing complete
* App runs cleanly without runtime errors

---
