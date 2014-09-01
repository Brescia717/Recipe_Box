require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry'

def db_connection
  log = []
  begin
    connection = PG.connect(dbname: 'recipes')
    log = connection.exec('SELECT name, id FROM recipes').to_a
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
  @recipe_names = @recipe_names.uniq.sort
  @recipe_ids = @recipe_ids.uniq

  erb :recipes
end

get '/recipes/:id' do
  @recipe_info = []
  @recipe_info = db_connection.find_all{|ids| ids["id"] == params[:id]}
  @recipe_info

  erb :recipes_id
end
