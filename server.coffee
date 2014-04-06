fs = require 'fs'
express  = require 'express'

env = process.env.NODE_ENV || 'development'
config = require('./config/config')[env]

mongoose = require('mongoose')
mongoose.connect(config.db)

GLOBAL.config = config
modelsPath = config.root + '/app/models'

app = express()
app.config = config
app.env = env
app.models = {}

require('./config/express')(app)

fs.readdirSync(modelsPath).forEach (file) ->
  model = require(modelsPath + '/' + file)()
  app.models[model.modelName] = model if model.modelName

require("#{__dirname}/app/controllers")(app)

app.listen app.get('port')
console.log "Express server listening on port #{app.get('port')} in #{app.env}"
exports.app = app