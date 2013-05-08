Sequelize = require 'sequelize'
fs        = require 'fs'
_         = require 'underscore'
modelsPath    = __dirname + '/../models'
config    = require '../config/config'

exportObj =
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
      logging: false


    if process.env.CIRCLECI

      ###
        CircleCI
      ###

      testOptions =
        host: 'localhost'
      _.extend globalOptions, testOptions

      sequelize = new Sequelize(
        'circle_test',
        'ubuntu',
        '',
        globalOptions
      )

    else
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

    relationships = @relationships
    models = @models

    #Hash of model objects to write to JSON file & share with client
    exportModels = {}
    fs.readdirSync(modelsPath).forEach (name) ->

      if name.indexOf('coffee') > 0
        return

      object = require modelsPath + '/' + name
      options = object.options || {}
      modelName = name.replace(/\.js$/i, '')

      #add uid to each model
      object.model = _.extend({uid:
        type: Sequelize.STRING
        validate:
          isUUID: 4
          notNull: true
          unique: true
      }, object.model)

      models[modelName]       = sequelize.define modelName, object.model, options
      exportModels[modelName] =
        model: object.model

      if object.relations
        relationships[modelName]          = object.relations
        exportModels[modelName].relations = object.relations

      #sequelize.sync()



    #Write to JSON
    fs.writeFileSync config.appRoot + 'client/config/clientOrmShare.json', JSON.stringify(exportModels)

    for modelName, relations of @relationships
      for relObject in relations

        if !_.isObject relObject.options
          relObject.options = {}

        @models[modelName][relObject.relation](@models[relObject.model], relObject.options)

    @instance = sequelize
    return @instance

  instance:      null
  SEQ:           Sequelize
  models:        []
  relationships: {}
  model: (name) ->
    @models[name]

module.exports = exportObj

#exportObj.setup()
