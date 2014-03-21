module.exports = (grunt) ->

  # Require all grunt plugins at once
  require('load-grunt-tasks')(grunt)

  # Path configurations
  LIB_PATH    = 'lib'
  SRC_PATH    = 'src'
  TEST_PATH   = 'test'
  PLUGIN_PATH = 'plugins'
  PERF_PATH   = 'perf'

  ###
  # tasks
  ###
  grunt.registerTask 'test',    [ 'mochacov:spec' ]
  grunt.registerTask 'cov',     [ 'mochacov:cov' ]
  grunt.registerTask 'travis',  [ 'mochacov:travis' ]
  grunt.registerTask 'build',   [ 'clean', 'coffee:build', 'test', 'wrap', 'uglify' ]
  grunt.registerTask 'build:perf', [ 'clean:perf', 'coffee', 'exec:browserify' ]
  grunt.registerTask 'default', [ 'test' ]
  grunt.registerTask 'perf',    [ 'build:perf', 'exec:perf' ]

  ###
  # config
  ###
  grunt.initConfig

    # Clean the lib folder
    clean:
      lib  : [ LIB_PATH ]
      perf : [ "#{PERF_PATH}/lib" ]

    # Execute commands
    exec :
      perf : cmd : (grep) ->
        grp = "--grep #{grep}" if grep
        "node #{PERF_PATH}/lib/node.perf #{grp}"

      browserify : cmd : "browserify #{PERF_PATH}/lib/node.perf > #{PERF_PATH}/lib/browser.perf.js"

    # Wrap the zimple.js in customized wrapper
    wrap :
      production:
        src     : "#{LIB_PATH}/src/zimple.js"
        dest    : 'zimple.js'
        options :
          wrapper : ['(function(global, undefined) {', '})(this);']

    # Compile coffee-script files to js
    coffee:
      # Performance files only
      perf  :
        options : bare : true
        files   : 'perf/lib/node.perf.js' :
          [
            "#{PERF_PATH}/runner-header.coffee",
            "#{TEST_PATH}/perf/**/*.perf.coffee",
            "#{PLUGIN_PATH}/**/*.perf.coffee",
            "#{PERF_PATH}/runner-footer.coffee" # This must be the last file
          ]

      # All files for building purposes
      build :
        options : bare : true
        files : 'lib/src/zimple.js' :
          [
            "#{SRC_PATH}/**/zimple.coffee",     # Core as first
            "#{PLUGIN_PATH}/**/*.coffee",       # Attach all the plugin files
            "!#{PLUGIN_PATH}/**/*.test.coffee", # Skip all the tests for building
            "!#{PLUGIN_PATH}/**/*.perf.coffee", # Skip all the tests for building
          ]

    # Uglify the end result
    uglify :
      build:
        options:
          report :'gzip'
        files  :
          'zimple.min.js' : [ 'zimple.js' ]

    # Coverage tests
    mochacov :
      travis :
        options : coveralls : serviceName : 'travis-ci'
      spec :
        options : reporter : 'spec'
      cov  :
        options : reporter : 'html-cov'
      options :
        compilers : [ 'coffee:coffee-script' ]
        files     : [ '**/*.test.coffee' ]
        require   : [ 'should' ]
        growl     : true
        ui        : 'tdd'

    # Watch for file changes.
    watch:
      lib:
        files : [ '**/*.coffee' ]
        tasks : [ 'test' ]
        options :
          nospawn : true
