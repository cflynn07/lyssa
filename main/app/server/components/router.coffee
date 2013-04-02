director  = require 'director'
fs        = require 'fs'
_         = require 'underscore'
wrench    = require 'wrench'

controllersPath = __dirname + '/../controllers'
router          = new director.http.Router({async:true})

wrench.readdirSyncRecursive(controllersPath).forEach (name) ->

  stats = fs.lstatSync controllersPath + '/' + name
  if stats.isDirectory()
    return

  if name.indexOf('coffee') > -1
    return
  controller = require controllersPath + '/' + name
  router.mount controller.callbacks, controller.route

module.exports = router
