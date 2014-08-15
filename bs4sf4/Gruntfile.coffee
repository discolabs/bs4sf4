module.exports = (grunt) ->

  # Initialise the Grunt config.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # Meta information about Bootstrap for Shopify.
    meta:
      banner:
        '// Bootstrap for Shopify\n' +
        '// version: <%= pkg.version %>\n' +
        '// author: <%= pkg.author %>\n' +
        '// license: <%= pkg.licenses[0].type %>\n'

    # Compilation of LESS files to compressed .css.liquid files.
    less:
      theme:
        options:
          compress: true
        files:
          'theme/assets/bootstrap.min.css.liquid': 'bower_components/bootstrap/less/bootstrap.less'

    # Compilation of theme settings from YAML files.
    shopify_theme_settings:
      settings:
        files:
          'theme/config/settings.html': 'settings/*.yml'

    # Copying of various theme files.
    copy:
      snippets:
        expand: true
        cwd: 'snippets'
        src: '**/**.liquid'
        dest: 'theme/snippets'
        rename: (dest, src)->
          path = require('path')
          path.join(dest, src.replace(path.sep, '-'))
      layout:
        expand: true
        cwd: 'layout'
        src: '*.liquid'
        dest: 'theme/layout'
      templates:
        expand: true
        cwd: 'templates'
        src: '*.liquid'
        dest: 'theme/templates'
      locales:
        expand: true
        cwd: 'locales'
        src: '*.json'
        dest: 'theme/locales'
      jquery:
        src: 'bower_components/jquery/dist/jquery.min.js'
        dest: 'theme/assets/jquery.min.js'
      bootstrapjs:
        src: 'bower_components/bootstrap/dist/js/bootstrap.min.js'
        dest: 'theme/assets/bootstrap.min.js'

    # Watch task.
    watch:
      less:
        files: ['less/**/*.less']
        tasks: ['less']
      settings:
        files: ['settings/*.yml']
        tasks: ['shopify_theme_settings']
      snippets:
        files: ['snippets/**/**.liquid']
        tasks: ['copy:snippets']
      layout:
        files: ['layout/*.liquid']
        tasks: ['copy:layout']
      templates:
        files: ['templates/*.liquid']
        tasks: ['copy:templates']
      locales:
        files: ['locales/*.json']
        tasks: ['copy:locales']

  # Load tasks made available through NPM.
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shopify-theme-settings'

  # Register tasks make available through the Gruntfile.
  grunt.registerTask 'build',   ['less', 'shopify_theme_settings', 'copy']
  grunt.registerTask 'default', ['build', 'watch']