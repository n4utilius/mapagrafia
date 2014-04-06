path = require "path"
rootPath = path.normalize(__dirname + '/..')

module.exports =
  development:
    db: "mongodb://localhost/mapagrafia_dev"
    port: 4000
    root: rootPath

  production:
    db: "mongodb://localhost/mapagrafia_prod"
    port: 80
    root: rootPath