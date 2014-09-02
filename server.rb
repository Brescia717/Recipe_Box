require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

def db_connection(sql)
  log = []
  begin
    connection = PG.connect(dbname: 'recipes')
    log = connection.exec(sql).to_a
  ensure
    connection.close
  end
end


get '/recipes' do
  @recipe_names = []
  @recipe_ids = []
  sql = 'SELECT * FROM ingredients JOIN recipes ON ingredients.recipe_id = recipes.id ORDER BY recipes.name ASC'

  db_connection(sql).each do |recipe|
    @recipe_names << recipe["name"]
    @recipe_ids << recipe["recipe_id"].to_i
  end
  @recipe_names = @recipe_names.uniq
  @recipe_ids = @recipe_ids.uniq

  erb :recipes
end

get '/recipes/:id' do
  sql = 'SELECT DISTINCT recipes.name, recipes.id FROM recipes JOIN ingredients ON recipes.id = ingredients.recipe_id ORDER BY recipes.name ASC'
  @recipe_info = []
  @recipe_info = db_connection(sql).find_all do |ids|
    ids["id"] == params[:id]

  end
  @recipe_info


  @ingredients = []
  sqll = 'SELECT DISTINCT ingredients.name, ingredients.recipe_id FROM ingredients JOIN recipes ON recipes.id = ingredients.recipe_id'
  @ingredients = db_connection(sqll).find_all do |recipe|
    recipe["recipe_id"] == params[:id]
  end
  @ingredients = @ingredients.uniq

  erb :recipes_id
end
