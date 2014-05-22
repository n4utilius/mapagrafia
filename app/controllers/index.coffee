_ = require 'underscore'
async = require 'async'
mongoose = require 'mongoose'
#spreadsheets = require "../lib/spreadsheets"
mapRaw = require "../lib/mx"
mapStates = require("../lib/states").mapStates
GoogleSpreadsheet = require("google-spreadsheet");
csv = require 'csv'
fs = require 'fs'

utils = {}

utils.csv_to_json = (fileUrl) ->
  data = []
  heads = []
  is_head = true;

  csv()
  .from.stream(fs.createReadStream(fileUrl), { delimiter: ',' })
  .transform( (row) ->
    row.unshift(row.pop())
    return row
  )
  .on('record', (row,index) ->
    if(is_head)
      heads = row
      is_head = false
    else
      obj = {}
      for i of row
        obj[heads[i]] = row[i]
      obj.id = index
      data.push(obj)
  )
  .on('end', (count) -> 
    return data
  )
  .on('error', (error) ->  console.log(error.message) )

utils.gsheet_to_json = (googleDocsKey) ->
  sheet = new GoogleSpreadsheet(googleDocsKey)
  data = []

  sheet.getRows( 1, (err, row_data) ->
    if !err
      console.log 'pulled in ' + row_data +  ' rows '
    else
      console.log err
  )

module.exports = (app) ->
  Mapagrafia = app.models.Mapagrafia

  app.get '/', (req, res) ->
    res.render 'index'


  app.get '/create', (req, res) ->
    res.render 'create'


  app.post '/create', (req, res) ->
    if req.body.googleDocsKey
      googleDocsKey = req.body.googleDocsKey
      #console.log googleDocsKey
      #req.body.mapData  = utils.gsheet_to_json googleDocsKey 
      utils.gsheet_to_json googleDocsKey 
    else
      fileUrl = req.files.file.path
      req.body.mapData  = utils.csv_to_json(fileUrl)

    #console.log req.body.mapData
    #new Mapagrafia(req.body).save (err, mapagrafia) ->
    #  if err
    #    console.log err
    #    return res.send(500)
    #  res.redirect "/map/#{mapagrafia._id}"
    res.redirect "/create"
    


  app.get '/map/:mapagrafiaId', (req, res) ->
    geometries = mapRaw.objects.states.geometries #mapa en geojson
    total = 0
    values = null

    async.waterfall [
      (done) ->
        Mapagrafia.findOne {_id: req.params.mapagrafiaId}, done
    ], (err, mapagrafia) ->
      newGeometries = _.map geometries, (geo) ->
        #he aqui el cambio
        values = mapagrafia.mapData
        geo.properties.value  = parseInt( values[geo.properties.state_code]?.Value or 0 )
        total += geo.properties.value
        geo

      res.render 'configMap',
        mapRaw: mapRaw
        total: total
        mapagrafia: mapagrafia


  app.get '/mg/:mapagrafiaId', (req, res) ->
    geometries = mapRaw.objects.states.geometries
    total = 0
    values = null

    async.waterfall [
      (done) ->
        Mapagrafia.findOne {_id: req.params.mapagrafiaId}, done
    ], (err, mapagrafia) ->
      newGeometries = _.map geometries, (geo) ->
        values = mapagrafia.mapData
        geo.properties.value  = parseInt( values[geo.properties.state_code]?.Value or 0 )
        total += geo.properties.value
        geo
      console.log mapagrafia
      res.render 'mapagrafia',
        mapRaw: mapRaw
        total: total
        mapagrafia: mapagrafia


  app.post '/map', (req, res) ->
    Mapagrafia.findOne {_id: req.body.mapagrafiaId}, (err, mapagrafia) ->
      if err
        console.log err
        return res.send 500
      mapagrafia.mapData = {} unless mapagrafia.mapData
      mapagrafia.mapData.title = req.body.mapTitle
      mapagrafia.save (err, mp) ->
        if err
          console.log err
          return res.send 500

        res.redirect "/mg/#{mapagrafia._id}"

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