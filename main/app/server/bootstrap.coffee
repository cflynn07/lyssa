crypto        = require 'crypto'
requirejs     = require 'requirejs'
async         = require 'async'
execSync      = require 'exec-sync'
fs            = require 'fs'


try
  output = execSync 'cd ~/code && pwd -P'
catch e
  console.log 'execSync error'
  console.log e
  try
    output = execSync 'cd ~/ && pwd'
  catch e
    output = Date.now() + ''

GLOBAL.asset_hash = crypto.createHash('md5').update(output).digest("hex")
console.log GLOBAL.asset_hash

localPath = __dirname + '/../client/assets/' + GLOBAL.asset_hash
if fs.existsSync(localPath + '.css') and fs.existsSync(localPath + '.js')
  require './server'

else
  async.parallel [
    (cb) ->

      #OPTIMIZE CSS
      requirejs.optimize
        cssIn:        __dirname + '/../client/assets/main.css'
        out:          __dirname + '/../client/assets/' + GLOBAL.asset_hash + '.css'
        optimizeCss: 'standard' #standard
        preserveLicenseComments: false
        (buildResponse) ->
          console.log 'requirejs br 1'
          console.log buildResponse
          cb()
            #console.log 'requirejs comp'
            #console.log buildResponse
        (err) ->
          console.log 'requirejs err 1'
          console.log err
          cb()
            #console.log 'requirejs err'
            #console.log err
    (cb) ->

      #OPTIMIZE JS
      config =
        baseUrl: __dirname + '/../client/'
      #  name:    'vendor/almond'
        name:    'vendor/require'
        include: './client'
     #   optimize: 'none' #'standard' #'none'
        preserveLicenseComments: false
        out:     __dirname + '/../client/assets/' + GLOBAL.asset_hash + '.js'
        paths:
          text:                 'vendor/text'
          'coffee-script':      'vendor/coffee-script'
          cs:                   'vendor/cs'
          hbs:                  'vendor/hbs'
          Handlebars:           'vendor/Handlebars'
          i18nprecompile:       'vendor/hbs/i18nprecompile'
          json2:                'vendor/hbs/json2'
          io:                   'vendor/socket.io'
          underscore:           'vendor/underscore'
          backbone:             'vendor/backbone'
          jquery:               'vendor/jquery'
          bootstrap:            'vendor/bootstrap'
          bootstrapFileUpload:  'vendor/bootstrap-fileupload'
          jqueryUniform:        'vendor/jquery.uniform'
          jqueryBrowser:        'vendor/jquery.browser'
          datatables:           'vendor/jquery-dataTables'
          datatables_bootstrap: 'vendor/DT_bootstrap'
          jqueryDateFormat:     'vendor/jquery-dateFormat'


          #File-upload assets
          jqueryFileUpload:       'vendor/file-upload/jquery.fileupload'
          jqueryFileUploadFp:     'vendor/file-upload/jquery.fileupload-fp'
          jqueryFileUploadUi:     'vendor/file-upload/jquery.fileupload-ui'
          jqueryIframeTransport:  'vendor/file-upload/jquery.iframe-transport'
          'jquery.ui.widget':     'vendor/file-upload/jquery.ui.widget'
          tmplMin:                'tmpl.min'

          jqueryAutoComplete:     'vendor/jquery-autocomplete/jquery-ui-1.10.2.custom'

        hbs:
          disableI18n: true
          helperDirectory: 'views/helpers/'
      #   templateExtension: 'hbs'

        shim:
          underscore:
            exports: '_'
          io:
            exports: 'io'
          cs:
            deps:    ['coffee-script']
          jquery:
            exports: '$'
          jqueryBrowser:
            deps:    ['jquery']
          jqueryUniform:
            deps:    ['jqueryBrowser', 'jquery']
          backbone:
            deps:    ['underscore', 'jquery']
            exports: 'Backbone'
          bootstrap:
            deps:    ['jquery']
          datatables:
            deps:    ['jquery']

          #File-upload assets
          jqueryFileUpload:
            deps:    ['jquery']
          jqueryFileUploadFp:
            deps:    ['jquery']
          jqueryFileUploadUi:
            deps:    ['jquery']
          jqueryIframeTransport:
            deps:    ['jquery']
          'jquery.ui.widget':
            deps:    ['jquery']
          tmplMin:
            deps:    ['jquery']

          jqueryAutoComplete:
            deps:    ['jquery']


      requirejs.optimize config,
        (buildResponse) ->
          console.log 'requirejs br 2'
          console.log buildResponse
          cb()
        (err) ->
          console.log 'requirejs err 2'
          console.log err
          cb()

  ], (err, results) ->
    require './server'

