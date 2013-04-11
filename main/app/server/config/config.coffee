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
  apiResponseCodes:

    #Non-errors
    200: "OK"
    201: "Created"
    202: "Accepted"

    #errors
    301: "Moved Permanently"
    400: "Bad Request"
    401: "Unauthorized"
    402: "Forbidden"
    404: "Not Found"
  errorResponse: (code = 401) ->

    if [301, 400, 401, 402, 404].indexOf(code) is -1
      throw new Error('Invalid API error response')
      return

    code: code
    error: @apiResponseCodes[code]
