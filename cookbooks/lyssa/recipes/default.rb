bash "import_database" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  mysql -uroot -ppassword -e "create database if not exists development"
  mysql development -uroot -ppassword -e "source /vagrant/main/app/tests/apiTests/lyssa.sql"
  EOH
end

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
  npm install -g supervisor
  EOH
end

bash "compile_coffeescript" do
  user "root"
  cwd "/vagrant/main/app"
  code <<-EOH
  coffee -c .
  EOH
end

bash "start_app" do
  user "root"
  cwd "/vagrant/main/app/server"
  code <<-EOH
  npm uninstall bcrypt
  npm install bcrypt
  nohup supervisor -w "./" server.js &
  EOH
end