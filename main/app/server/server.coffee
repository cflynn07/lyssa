
app = require './app'


#Regular Routes
app.get '/', require('./controllers/index')

#API Routes
require('./controllers/api/users')(app)


app.listen app.get 'port'
console.log 'server listening on port: ' + app.get 'port'
