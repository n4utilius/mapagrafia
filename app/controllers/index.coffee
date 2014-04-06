_ = require 'underscore'
async = require 'async'
spreadsheets = require "../lib/spreadsheets"
mapRaw = require "../lib/mx"


module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'index'


  app.get '/spreadsheets/:key', (req, res) ->
    spreadsheets.get req.params.key, (err, data) ->
      if err
        console.log err
        return res.send err.message

      res.send data


  app.get '/map', (req, res) ->
    geometries = mapRaw.objects.states.geometries
    total = 0

    async.waterfall [
      (done) ->
        spreadsheets.get 'key', done
    ], (err, values) ->
      newGeometries = _.map geometries, (geo) ->
        geo.properties.value  = values[geo.properties.state_code]?.value or 0
        total += geo.properties.value
        geo

      res.render 'map',
        mapRaw: mapRaw
        total: total


  return