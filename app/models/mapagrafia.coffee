mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->

  MapagrafiaSchema = new Schema
    title: {type: String, default: ''}
    description: {type: String, default: ''}
    googleDocsKey: {type: String, default: '1MuKCo_Foq4Cm7g41yp2UHXLxOqywuTMKz8MSYz8fPHI'}
    mapData: { type: Schema.Types.Mixed }
    fileData:
      file: { type: Schema.Types.Mixed }

  mongoose.model 'Mapagrafia', MapagrafiaSchema