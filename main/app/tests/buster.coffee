config = module.exports
config['Tests'] =
  rootPath: "."
  environment: "node"
#These are not required for nodejs tests
#  sources: [
#    'lib/mylib.js'
#    'lib/**/*.js'
#  ]
  tests: [
   # './**/*-test.js'
   # 'integrationTests/**/*-test.js'
    '**/*Test.js'
  ]
