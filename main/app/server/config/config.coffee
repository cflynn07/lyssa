_ = require 'underscore'

module.exports =

  apiSubDir: '/api'
  appRoot:   __dirname + '/../../'
  env:       (if GLOBAL.app? and GLOBAL.app.settings? and GLOBAL.app.settings.env then GLOBAL.app.settings.env else 'development')
  assetHash: (if GLOBAL.assetHash then GLOBAL.assetHash else 'main')
  authCategories: [
  #  'super_admin'
  #  'client_super_admin'
  #  'client_admin'
  #  'client_delegate'
  #  'client_auditor'
    'superAdmin'
    'clientSuperAdmin'
    'clientAdmin'
    'clientDelegate'
    'clientAuditor'
  ]
  fieldTypes: [
    'openResponse'
    'selectIndividual'
    'selectMultiple'
    'yesNo'
    'slider'
  ]
  apiResponseErrors:
    'nestedTooDeep':
      code: 400
      message: 'extend can not nest resources deeper than two levels'
    'invalidExpandJSON':
      code: 400
      message: 'invalid expand JSON parameter'
    'unknownExpandResource':
      code: 400
      message: 'unknown expand resource'
    'circularExpand':
      code: 400
      message: ''
    'unknownRootResourceId':
      code: 404
      message: 'unknown resource uid specified'

  apiResponseCodes:

    #Non-errors
    200: 'OK'
    201: 'Created'
    202: 'Accepted'

    #errors
    301: 'Moved Permanently'
    400: 'Bad Request'
    401: 'Unauthorized'
    402: 'Forbidden'
    404: 'Not Found'

  response: (code = 200) ->
    if [200, 201, 202].indexOf(code) is -1
      throw new Error 'Invalid API response'
      return
    code: code
    message: @apiResponseCodes[code]

  errorResponse: (code = 401) ->

    if [301, 400, 401, 402, 404].indexOf(code) is -1
      throw new Error 'Invalid API error response'
      return

    code: code
    error: @apiResponseCodes[code]
  apiErrorResponse: (apiResponseErrorName) ->

    apiResponseErrorsObject = @apiResponseErrors[apiResponseErrorName]

    if _.isUndefined apiResponseErrorsObject
      throw new Error 'Invalid API error response'
      return

    _.extend @errorResponse(apiResponseErrorsObject.code), message: apiResponseErrorsObject.message
