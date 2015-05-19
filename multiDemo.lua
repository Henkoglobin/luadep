-- multiDemo.lua
-- 
-- Demonstrates how to use luadep to define a dependency that accepts multiple modules.

local module = require("module")
local container = require("container")

local recipeBook = module({})
	:setName("VanillaRecipeBook")
	:setVersion("1.0.0-beta")
	:isA("RecipeBook")
	:dependsOn("Recipe", "0..*")

local pancakes = module({
		Name = "Tasty pancakes"
	})
	:setName("VanillaPancakeRecipe")
	:setVersion("1.0.0-beta")
	:isA("Recipe")

local cheesecake = module({
		Name = "Fresh cheesecake"
	})
	:setName("henkoglobin-CheesecakeRecipe")
	:setVersion("0.1.0")
	:isA("Recipe")

local myContainer = container()
myContainer:collect(recipeBook)
myContainer:collect(pancakes)
myContainer:collect(cheesecake)

local myRecipes = myContainer:get("RecipeBook")

for _, recipe in pairs(myRecipes.Recipe) do
	print(("I know how to cook %s"):format(recipe.Name))
end