module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffeelint:
      client:    [
        'app/client/**/*.coffee'
      ]
      server:    [
        'app/server/**/*.coffee'
      ]
      options:
        max_line_length:
          level: 'ignore'

  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', ['coffeelint']

#  grunt.registerTask 'default', 'Log some stuff.', () ->
#    grunt.log.write('Logging some stuff...').ok()