module.exports =
  apiSubDir: '/api'
  appRoot:   __dirname + '/../../'
  env:       (if GLOBAL.app? and GLOBAL.app.settings? and GLOBAL.app.settings.env then GLOBAL.app.settings.env else 'development')
  assetHash: (if GLOBAL.assetHash then GLOBAL.assetHash else 'main')
  authCategories: [
    'super_admin'
    'client_super_admin'
    'client_admin'
    'client_delegate'
    'client_auditor'
  ]
  fieldTypes: [
    'openResponse'
    'selectIndividual'
    'selectMultiple'
    'yesNo'
    'slider'
  ]
  unauthorizedResponse:
    code: 401
    error: 'Unauthorized'
