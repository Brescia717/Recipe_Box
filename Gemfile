source "https://rubygems.org"

gem 'sinatra'
gem 'sinatra-contrib'
gem 'pg'
gem 'pry'


<html>
<body>
  <% @i = 0 %>

  <% @recipes.each do |recipe| %>
      <p><a href="/recipes/<%=@recipes_id[@i]%>"><%= recipe %></a></p>
    <% @i += 1 %>
  <% end %>
</body>
</html>
