require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

def db_connection
  log = []
  begin
    connection = PG.connect(dbname: 'recipes')
    log = connection.exec('SELECT DISTINCT recipes.name, recipes.id FROM recipes JOIN ingredients ON recipes.id = ingredients.recipe_id ORDER BY recipes.name ASC').to_a
  ensure
    connection.close
  end
end


get '/recipes' do
  @recipe_names = []
  @recipe_ids = []

  db_connection.each do |recipe|
    @recipe_names << recipe["name"]
    @recipe_ids << recipe["id"].to_i
  end
  @recipe_names = @recipe_names.uniq
  @recipe_ids = @recipe_ids.uniq

  erb :recipes
end

get '/recipes/:id' do
  @recipe_info = []
  @recipe_info = db_connection.find_all{|ids| ids["id"] == params[:id]}
  @recipe_info

  erb :recipes_id
end
