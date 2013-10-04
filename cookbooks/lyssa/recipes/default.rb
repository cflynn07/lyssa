
# externalize conection info in a ruby hash
#mysql_connection_info = {
#  :host => "localhost",
#  :username => 'root',
#  :password => node['mysql']['server_root_password']
#}

# drop if exists, then create a mysql database named DB_NAME
#mysql_database 'development' do
#  connection mysql_connection_info
#  action [:drop, :create]
#end

#or import from a dump file
#mysql_database "development" do
#  connection mysql_connection_info
#  sql "source /vagrant/main/app/tests/apiTests/lyssa.sql;"
#end
###



bash "install_global_npm_modules" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  npm install -g ejs
  npm install -g jade
  npm install -g less
  npm install -g coffee-script
  npm install -g nodefront
  npm install -g hbs
  npm install -g marked
  npm install -g sass
  npm install -g nodefront
  npm install -g nodemon
  npm install -g grunt
  EOH
end

bash "start_app" do
  user "root"
  cwd "/vagrant/main/app/server"
  code <<-EOH
  nodemon server.js
  EOH
end