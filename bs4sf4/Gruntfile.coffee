module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # Meta information about Boostrap for Shopify.
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

    # Watch task.
    watch:
      less:
        files: 'less/**/*.less'
        tasks: ['less']
      settings:
        files: 'settings/*.yml'
        tasks: ['shopify_theme_settings']

  # Load tasks made available through NPM.
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shopify-theme-settings'

  # Register tasks make available through the Gruntfile.
  grunt.registerTask 'build',   ['less', 'shopify_theme_settings']
  grunt.registerTask 'default', ['build', 'watch']