// Generated by CoffeeScript 1.4.0
(function() {

  module.exports = function(grunt) {
    grunt.initConfig({
      pkg: grunt.file.readJSON('package.json'),
      coffeelint: {
        client: ['app/client/**/*.coffee'],
        server: ['app/server/**/*.coffee'],
        options: {
          max_line_length: {
            level: 'ignore'
          }
        }
      }
    });
    grunt.loadNpmTasks('grunt-coffeelint');
    return grunt.registerTask('default', ['coffeelint']);
  };

}).call(this);
