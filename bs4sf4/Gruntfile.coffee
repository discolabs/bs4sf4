module.exports = (grunt) ->

  # A small helper method that renames layout, snippet and template files for use in a single directory.
  rename = (dest, src)->
    path = require('path')
    path.join(dest, src.replace(path.sep, '-'))

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

    # Copying of various liquid template files.
    copy:
      layouts:
        expand: true
        cwd: 'layouts'
        src: '**/**.liquid'
        dest: 'theme/layouts'
        rename: rename
      snippets:
        expand: true
        cwd: 'snippets'
        src: '**/**.liquid'
        dest: 'theme/snippets'
        rename: rename
      templates:
        expand: true
        cwd: 'templates'
        src: '**/**.liquid'
        dest: 'theme/templates'
        rename: rename

    # Watch task.
    watch:
      less:
        files: ['less/**/*.less']
        tasks: ['less']
      settings:
        files: ['settings/*.yml']
        tasks: ['shopify_theme_settings']
      layouts:
        files: ['layouts/**/**.liquid']
        tasks: ['copy:layouts']
      snippets:
        files: ['snippets/**/**.liquid']
        tasks: ['copy:snippets']
      templates:
        files: ['templates/**/**.liquid']
        tasks: ['copy:templates']

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