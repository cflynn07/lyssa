config = module.exports
config['My tests'] =
  rootPath: "."
  environment: "node"
#These are not required for nodejs tests
#  sources: [
#    'lib/mylib.js'
#    'lib/**/*.js'
#  ]
  tests: [
   # './**/*-test.js'
    'integrationTests/**/*-test.js'
    'unitTests/**/*-test.js'
  ]
