Sequelize = require 'sequelize'
fs        = require 'fs'
_         = require 'underscore'


modelsPath    = __dirname + '/../models'
relationships = {}
models        = []


#setup
setup = () ->

  globalOptions =
    pool:
      maxConnections: 5
      maxIdleTime: 30
    define:
      underscored: false
    syncOnAssociation: false
    paranoid: true



  # 'lyssa' is my development DB
  #& 'production' is production on dotcloud
  if GLOBAL.env? && GLOBAL.env.DOTCLOUD_DB_MYSQL_LOGIN?

    productionOptions =
      host: GLOBAL.env.DOTCLOUD_DB_MYSQL_HOST
      port: GLOBAL.env.DOTCLOUD_DB_MYSQL_PORT
    _.extend globalOptions, productionOptions

    sequelize = new Sequelize(
      'production',
      GLOBAL.env.DOTCLOUD_DB_MYSQL_LOGIN,
      GLOBAL.env.DOTCLOUD_DB_MYSQL_PASSWORD,
      globalOptions
    )

  else

    localOptions =
      host: 'localhost'
      port: '8889'
    _.extend globalOptions, localOptions

    sequelize = new Sequelize(
      'lyssa',
      'root',
      'root',
      globalOptions
    )


  fs.readdirSync(modelsPath).forEach (name) ->

    if name.indexOf('coffee') > 0
      return

    object = require modelsPath + '/' + name
    options = object.options || {}
    modelName = name.replace(/\.js$/i, '')
    models[modelName] = sequelize.define modelName, object.model, options
    if object.relations?
      relationships[modelName] = object.relations

  for relation, modelName in relationships
    for relName in relation
      related = relation[relName]
      models[modelName][relName][models[related]]

  #sequelize.sync()


module.exports =
  SEQ: Sequelize
  setup: setup
  model: (name) ->
    models[name]
