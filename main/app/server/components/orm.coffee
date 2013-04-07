Sequelize = require 'sequelize'
fs        = require 'fs'
_         = require 'underscore'
modelsPath    = __dirname + '/../models'

module.exports =
  setup: (mode = 'standard') ->

    if @instance
      return @instance

    globalOptions =
      pool:
        maxConnections: 5
        maxIdleTime: 30
      define:
        underscored: false
      syncOnAssociation: false
      paranoid: true

    if mode is 'standard'

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



        ###
          Local
        ###
        localOptions =
          host: 'localhost'
          port: 3306
        _.extend globalOptions, localOptions

        sequelize = new Sequelize(
          'lyssa',
          'root',
          '',
          globalOptions
        )



    else

      ###
        CircleCI
      ###
      if mode is 'testing'

        testOptions =
          host: 'localhost'
        _.extend globalOptions, testOptions

        sequelize = new Sequelize(
          'circle_test',
          'ubuntu',
          '',
          globalOptions
        )


    relationships = @relationships
    models = @models
    fs.readdirSync(modelsPath).forEach (name) ->

      if name.indexOf('coffee') > 0
        return

      console.log name

      object = require modelsPath + '/' + name
      options = object.options || {}
      modelName = name.replace(/\.js$/i, '')
      models[modelName] = sequelize.define modelName, object.model, options

      if object.relations
        relationships[modelName] = object.relations



    for modelName, relations of @relationships
      for relObject in relations
        @models[modelName][relObject.relation](@models[relObject.model])

      #  console.log relName
      #  console.log relModel
      #  console.log modelName + ' ' + relName + ' ' + relModel
      #  @models[modelName][relName](@models[relModel])




    @instance = sequelize
    return @instance

  instance:      null
  SEQ:           Sequelize
  models:        []
  relationships: {}

  model: (name) ->
    @models[name]
