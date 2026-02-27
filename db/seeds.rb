# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding ingredients..."

ingredients_list = [
  "tomato", "onion", "garlic", "olive oil", "basil", "pasta", "salt", "black pepper",
  "rice", "cumin", "turmeric", "ginger", "green chili", "cilantro", "lemon",
  "chickpeas", "coconut milk", "curry leaves", "mustard seeds", "potato",
  "carrot", "peas", "bell pepper", "soy sauce", "tofu", "sesame oil", "green onion",
  "mushroom", "spinach", "feta cheese", "oregano", "cucumber", "olives",
  "red kidney beans", "corn", "avocado", "lime", "jalapeno", "tortilla",
  "broccoli", "cashews", "cream", "cardamom", "cinnamon", "garam masala"
]

ingredients = {}
ingredients_list.each do |name|
  ingredients[name] = Ingredient.find_or_create_by!(name: name)
end

puts "Seeding recipes..."

recipes = [
  {
    name: "Pasta Pomodoro",
    description: "Classic Italian pasta with fresh tomato sauce",
    prep_time: 25,
    diet_type: "vegan",
    instructions: "1. Boil water and cook pasta according to package directions.\n2. Heat olive oil in a pan and sauté minced garlic until golden.\n3. Add chopped tomatoes and cook for 10 minutes.\n4. Season with salt, pepper, and fresh basil.\n5. Toss pasta with the sauce and serve hot.",
    ingredient_names: ["pasta", "tomato", "garlic", "olive oil", "basil", "salt", "black pepper"]
  },
  {
    name: "Vegetable Biryani",
    description: "Aromatic Indian rice dish with mixed vegetables",
    prep_time: 45,
    diet_type: "vegan",
    instructions: "1. Soak basmati rice for 30 minutes.\n2. Sauté onions, ginger, and green chili until golden.\n3. Add mixed vegetables and spices (cumin, turmeric, garam masala).\n4. Layer rice and vegetables, add water and cook until done.\n5. Garnish with cilantro and serve with lemon wedges.",
    ingredient_names: ["rice", "onion", "ginger", "green chili", "cumin", "turmeric", "carrot", "peas", "potato", "cilantro", "lemon", "garam masala", "salt"]
  },
  {
    name: "Chickpea Curry",
    description: "Hearty and flavorful North Indian curry",
    prep_time: 30,
    diet_type: "vegan",
    instructions: "1. Sauté onions, garlic, and ginger until golden.\n2. Add cumin, turmeric, and curry powder.\n3. Add chickpeas and tomato puree.\n4. Simmer for 15 minutes with coconut milk.\n5. Garnish with cilantro and serve with rice.",
    ingredient_names: ["chickpeas", "onion", "garlic", "ginger", "cumin", "turmeric", "tomato", "coconut milk", "cilantro", "rice", "salt"]
  },
  {
    name: "Tofu Stir Fry",
    description: "Quick and healthy Asian-inspired dish",
    prep_time: 20,
    diet_type: "vegan",
    instructions: "1. Press and cube tofu, pan-fry until golden.\n2. Stir-fry broccoli, bell pepper, and carrots.\n3. Add soy sauce, sesame oil, and ginger.\n4. Toss in tofu and green onions.\n5. Serve hot over rice.",
    ingredient_names: ["tofu", "broccoli", "bell pepper", "carrot", "soy sauce", "sesame oil", "ginger", "green onion", "rice"]
  },
  {
    name: "Mediterranean Salad",
    description: "Fresh and healthy Greek-style salad",
    prep_time: 15,
    diet_type: "veg",
    instructions: "1. Chop cucumber, tomato, and bell pepper.\n2. Add sliced olives and red onion.\n3. Crumble feta cheese on top.\n4. Drizzle with olive oil and lemon juice.\n5. Season with oregano, salt, and pepper.",
    ingredient_names: ["cucumber", "tomato", "bell pepper", "olives", "onion", "feta cheese", "olive oil", "lemon", "oregano", "salt", "black pepper"]
  },
  {
    name: "Palak Tofu",
    description: "Indian spinach curry with tofu",
    prep_time: 35,
    diet_type: "vegan",
    instructions: "1. Blanch spinach and blend into a puree.\n2. Sauté onions, garlic, ginger, and spices.\n3. Add tofu cubes and spinach puree.\n4. Simmer with cream or coconut milk.\n5. Garnish with cilantro and serve.",
    ingredient_names: ["spinach", "tofu", "onion", "garlic", "ginger", "cumin", "turmeric", "garam masala", "coconut milk", "cilantro", "salt"]
  },
  {
    name: "Mushroom Risotto",
    description: "Creamy Italian rice dish with mushrooms",
    prep_time: 40,
    diet_type: "veg",
    instructions: "1. Sauté mushrooms until golden, set aside.\n2. Cook onions and garlic in olive oil.\n3. Add rice and toast for 2 minutes.\n4. Gradually add vegetable broth, stirring constantly.\n5. Stir in mushrooms, feta, and season with salt and pepper.",
    ingredient_names: ["mushroom", "rice", "onion", "garlic", "olive oil", "feta cheese", "salt", "black pepper"]
  },
  {
    name: "Bean Burrito Bowl",
    description: "Mexican-inspired rice bowl with beans",
    prep_time: 25,
    diet_type: "vegan",
    instructions: "1. Cook rice with cumin and lime juice.\n2. Season and heat kidney beans.\n3. Prepare toppings: corn, avocado, tomato, jalapeno.\n4. Assemble bowl with rice, beans, and toppings.\n5. Garnish with cilantro and lime.",
    ingredient_names: ["rice", "red kidney beans", "corn", "avocado", "tomato", "jalapeno", "lime", "cilantro", "cumin", "salt"]
  },
  {
    name: "Cashew Curry",
    description: "Rich and creamy cashew-based curry",
    prep_time: 35,
    diet_type: "vegan",
    instructions: "1. Soak cashews for 30 minutes, then blend.\n2. Sauté onions, garlic, and ginger.\n3. Add spices and vegetables (carrots, peas).\n4. Add cashew cream and simmer.\n5. Garnish with cilantro and serve.",
    ingredient_names: ["cashews", "onion", "garlic", "ginger", "carrot", "peas", "cumin", "turmeric", "garam masala", "coconut milk", "cilantro", "rice", "salt"]
  },
  {
    name: "Garlic Butter Pasta",
    description: "Simple and delicious pasta with garlic butter",
    prep_time: 15,
    diet_type: "veg",
    instructions: "1. Cook pasta according to package directions.\n2. Melt butter in a pan and sauté garlic until fragrant.\n3. Toss pasta with garlic butter.\n4. Add parsley, salt, and pepper.\n5. Top with feta cheese if desired.",
    ingredient_names: ["pasta", "garlic", "olive oil", "basil", "salt", "black pepper", "feta cheese"]
  },
  {
    name: "Vegetable Fried Rice",
    description: "Classic Chinese-style fried rice",
    prep_time: 20,
    diet_type: "vegan",
    instructions: "1. Cook rice and let it cool.\n2. Scramble tofu in a pan, set aside.\n3. Stir-fry mixed vegetables (peas, carrot, corn).\n4. Add rice, soy sauce, and sesame oil.\n5. Garnish with green onions.",
    ingredient_names: ["rice", "tofu", "peas", "carrot", "corn", "soy sauce", "sesame oil", "green onion", "garlic", "ginger"]
  },
  {
    name: "Caprese Salad",
    description: "Fresh Italian salad with tomato and mozzarella",
    prep_time: 10,
    diet_type: "veg",
    instructions: "1. Slice tomatoes and arrange on a plate.\n2. Add fresh basil leaves between slices.\n3. Drizzle with olive oil and balsamic.\n4. Season with salt and pepper.\n5. Serve immediately.",
    ingredient_names: ["tomato", "basil", "olive oil", "salt", "black pepper"]
  }
]

recipes.each do |recipe_data|
  ingredient_names = recipe_data.delete(:ingredient_names)
  
  recipe = Recipe.create!(recipe_data)
  
  ingredient_names.each do |name|
    ingredient = Ingredient.find_by!(name: name)
    RecipeIngredient.create!(recipe: recipe, ingredient: ingredient)
  end
end

puts "Seeding complete! Created #{Recipe.count} recipes with #{Ingredient.count} ingredients."
