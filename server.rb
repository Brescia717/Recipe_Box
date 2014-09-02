require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

# def db_connection(sql)
#   log = []
#   begin
#     connection = PG.connect(dbname: 'recipes')
#     log = connection.exec(sql).to_a
#   ensure
#     connection.close
#   end
# end

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end


get '/recipes' do
  query = 'SELECT recipes.name AS name, recipes.id AS id FROM recipes ORDER BY recipes.name'

  @recipe_names = db_connection do |conn|
    conn.exec(query)
  end

  erb :recipes
end

get '/recipes/:id' do
  selected = params[:id]
  query = 'SELECT recipes.name AS name, recipes.description AS description, recipes.instructions AS instructions,
   ingredients.name AS ingredients FROM recipes LEFT OUTER JOIN ingredients ON ingredients.recipe_id = recipes.id WHERE recipes.id = $1'

  @recipe_info = db_connection do |conn|
    conn.exec(query, [selected])
  end

  erb :recipes_id
end




# get '/recipes' do
#   @recipe_names = []
#   @recipe_ids = []
#   recipes = 'SELECT recipes.name AS name, recipes.id AS id FROM recipes ORDER BY name' # JOIN ingredients ON ingredients.recipe_id = recipes.id ORDER BY recipes.name ASC'

#   db_connection(recipes).each do |recipe|
#       @recipe_names << recipe["name"]
#     @recipe_names = @recipe_names.uniq
#       @recipe_ids << recipe["id"]
#     @recipe_ids = @recipe_ids.uniq
#   end
#   @recipe_names
#   @recipe_ids

#   erb :recipes
# end

# get '/recipes/:id' do
#   info = 'SELECT recipes.name AS name, recipes.id AS id, recipes.description AS description, recipes.instructions AS instructions FROM recipes LEFT OUTER JOIN ingredients ON ingredients.recipe_id = recipes.id WHERE recipes.id = $1'
#   @recipe_info = []
#   @recipe_info = db_connection(info).find_all do |ids|
#     ids["id"] == params[:id]

#   end
#   @recipe_info


#   @ingredients = []
#   ingredients = 'SELECT DISTINCT ingredients.name, ingredients.recipe_id FROM ingredients INNER JOIN recipes ON recipes.id = ingredients.recipe_id'
#   @ingredients = db_connection(ingredients).find_all do |recipe|
#     recipe["recipe_id"] == params[:id]
#   end
#   @ingredients = @ingredients.uniq

#   erb :recipes_id
# end
