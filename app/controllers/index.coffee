_ = require 'underscore'
async = require 'async'
spreadsheets = require "../lib/spreadsheets"
mapRaw = require "../lib/mx"
mapStates = require("../lib/states").mapStates


module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render 'index'

  app.get '/create', (req, res) ->
    res.render 'create'

  app.get '/configMap', (req, res) ->
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

      res.render 'configMap',
        mapRaw: mapRaw
        total: total


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

  app.get '/graphics', (req, res) ->
    spreadsheets.get 'key', (err, values) ->
      data = {name: 'Estados'}

      data.children = _.map values, (k, v )  ->
        k.name = mapStates[v]
        k

      res.render 'graphics',
        data: data

  return