express = require 'express'

module.exports = (app) ->

  port = app.config.port  || 4000

  app.configure 'develompent', ->
    app.use express.errorHandler()

  app.use express.static("#{app.config.root}/public")
  app.use express.logger('dev')
  app.use express.bodyParser()

  app.set 'port', port
  app.set 'showStackError', true
  app.set 'views', "#{app.config.root}/app/views"
  app.set 'view engine', "jade"
  app.set 'view options',
    pretty: true



  return