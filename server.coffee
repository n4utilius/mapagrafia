express  = require 'express'

app = express()

app.configure 'develompent', ->
  app.use express.errorHandler()

app.use express.static("#{__dirname}/public")
app.use express.logger('dev')
app.set 'views', "#{__dirname}/app/views"
app.set 'view engine', "jade"
app.set 'view options',
  pretty: true

require("#{__dirname}/app/controllers")(app)

app.listen 4000
console.log "app running in port 4000"