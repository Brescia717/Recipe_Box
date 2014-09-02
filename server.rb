require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

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
