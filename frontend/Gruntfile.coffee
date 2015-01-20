#### js2coffee version 0.3.3
#### ---- .old/Gruntfile.js
true
# Generated on 2014-11-25 using generator-angular 0.10.0
'use strict'

# Great help to work with LAMP approach
# http://darrenhall.info/development/yeoman-and-mamp

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->

  # Load grunt tasks automatically
  require('load-grunt-tasks') grunt

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt') grunt

  # Configurable paths for the application
  appConfig =
    app: require('./bower.json').appPath or 'app'
    dist: 'dist'
    public: '../public'
    layout: '../module/Direct/view/layout'
    index: '../module/Direct/view/index'
    bower: 'bower_components'


  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    yeoman: appConfig

    # Watches files for changes and runs tasks based on the changed files
    watch:
      bower:
        files: ['bower.json']
        tasks: ['wiredep']

      coffee:
        files: ['<%= yeoman.app %>/scripts/**/*.{coffee,litcoffee,coffee.md}']
        tasks: ['newer:coffeelint:dist', 'newer:coffee:dev']
        options:
          spawn: false

      coffeeTest:
        files: ['test/spec/{,*/}*.{coffee,litcoffee,coffee.md}']
        tasks: [
          'newer:coffee:test'
          'karma'
        ]

      # coffeelint:
      #   files: ['<%= yeoman.app %>/scripts/**/*.{coffee,litcoffee,coffee.md}']
      #   tasks: ['newer:coffeelint:dist']

      bootstrap:
        files: ['<%= yeoman.app %>/scripts/libs/**/*.html']
        tasks: ['html2js:bootstrap', 'copy:public']

      multiselect:
        files: ['<%= yeoman.app %>/scripts/libs/**/*.html']
        tasks: ['html2js:multiselect', 'copy:public']

      mktplace:
        files: [
          '<%= yeoman.app %>/scripts/components/**/*.html'
          '<%= yeoman.app %>/scripts/shared/**/*.html'
        ]
        tasks: ['html2js:marketplace', 'copy:public']

      copy:
        files: ['<%= yeoman.app %>/*.phtml']
        tasks: ['copy:layout', 'copy:index']

      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: [
          'compass:dev'
          'autoprefixer:dev'
        ]

      images:
        files: ['<%= yeoman.app %>/images/**/*']
        tasks: ['copy:public']

      gruntfile:
        files: ['Gruntfile.js']

      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'

        files: [
          '<%= yeoman.app %>/**/*.{html,php,phtml,coffee,js,css,scss,sass}'
          # '.tmp/styles/**/*.css'
          # '.tmp/scripts/**/*.js'
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]


    # The actual grunt server settings
    connect:
      options:
        port: 9000

        # Change this to '0.0.0.0' to access the server from outside.
        hostname: 'localhost'
        livereload: 35729

      livereload:
        options:
          open: true
          middleware: (connect) ->
            [
              connect.static('.tmp')
              connect().use('/bower_components', connect.static('./bower_components'))
              connect.static(appConfig.app)
            ]

      test:
        options:
          port: 9001
          middleware: (connect) ->
            [
              connect.static('.tmp')
              connect.static('test')
              connect().use('/bower_components', connect.static('./bower_components'))
              connect.static(appConfig.app)
            ]

      dist:
        options:
          open: true
          base: '<%= yeoman.dist %>'


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')

      all:
        src: ['Gruntfile.js']


    # Empties folders to start fresh
    clean:
      options:
        force: true
      dist:
        files: [
          dot: true
          src: [
            '.tmp'
            '<%= yeoman.dist %>/{,*/}*'
            '!<%= yeoman.dist %>/.git{,*/}*'
          ]
        ]

      server: '.tmp'

      public:
        files: [
          src: [
            '<%= yeoman.public %>/**/*'
            '!<%= yeoman.public %>/index.php'
            '!<%= yeoman.public %>/.htaccess'
          ]
        ]

      layout: '<%= yeoman.layout %>/{,*/}*'

      index: '<%= yeoman.index %>/{,*/}*'


    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ['last 1 version']

      dist:
        files: [
          expand: true
          cwd: '.tmp/styles/'
          src: '{,*/}*.css'
          dest: '.tmp/styles/'
        ]

      dev:
        files: [
          expand: true
          cwd: '<%= yeoman.public %>/styles/'
          src: '{,*/}*.css'
          dest: '<%= yeoman.public %>/styles/'
        ]


    # Automatically inject Bower components into the app
    wiredep:
      app:
        src: ['<%= yeoman.app %>/layout.phtml','<%= yeoman.dist %>/layout.phtml']
        exclude: [
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/affix.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/alert.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/button.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/carousel.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/collapse.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/dropdown.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/modal.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/popover.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/scrollspy.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tab.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tooltip.js'
          'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/transition.js'
        ]
        ignorePath: /\.\.\//

      sass:
        src: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        ignorePath: /(\.\.\/){1,2}bower_components\//


    # The other views
    html2js:
      marketplace:
        options:
          base: 'app'
          module: 'marketplace.templates'
          singleModule: true
          useStrict: true
          htmlmin:
            collapseBooleanAttributes: true
            collapseWhitespace: true
            removeAttributeQuotes: true
            removeComments: true
            removeEmptyAttributes: true
            removeRedundantAttributes: true
            removeScriptTypeAttributes: true
            removeStyleLinkTypeAttributes: true

        src: [
          'app/scripts/components/**/*.html'
          'app/scripts/shared/**/*.html'
          'app/scripts/utils/**/*.html'
        ]
        dest: 'app/scripts/marketplace-templates.js'

      # Templates for Angular
      bootstrap:
        options:
          base: 'app/scripts/libs/angular-bootstrap/'
          module: 'ui-templates'
          rename: (modulePath) ->
            moduleName = modulePath.replace('app/scripts/libs/angular-bootstrap/', '')
            'template/' + moduleName

        src: ['app/scripts/libs/angular-bootstrap/**/*.html']
        dest: 'app/scripts/ui-templates.js'

      # Templates for Angular
      multiselect:
        options:
          base: 'app/scripts/libs/angular-multiselect/'
          module: 'ui-multiselect'
          rename: (modulePath) ->
            moduleName = modulePath.replace('app/scripts/libs/angular-multiselect/', '')
            'template/' + moduleName

        src: ['app/scripts/libs/angular-multiselect/**/*.html']
        dest: 'app/scripts/ui-multiselect.js'


    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ''
        bare: true
        spawn: false

      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/scripts'
          src: '**/*.coffee'
          dest: '.tmp/scripts'
          ext: '.js'
        ]

      test:
        files: [
          expand: true
          cwd: 'test/spec'
          src: '**/*.coffee'
          dest: '.tmp/spec'
          ext: '.js'
        ]

      dev:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/scripts'
          src: '**/*.coffee'
          dest: '<%= yeoman.public %>/scripts'
          ext: '.js'
        ]

    coffeelint:
      dist:
        files:
          src: ['<%= yeoman.app %>/scripts/**/*.coffee']

      options:
        configFile: 'coffeelint.json'

    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '.tmp/styles'
        generatedImagesDir: '.tmp/images/generated'
        imagesDir: '<%= yeoman.app %>/images'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: './bower_components'
        httpImagesPath: '/images'
        httpGeneratedImagesPath: '/images/generated'
        httpFontsPath: '/styles/fonts'
        relativeAssets: false
        assetCacheBuster: false
        raw: 'Sass::Script::Number.precision = 10\n'

      dist:
        options:
          generatedImagesDir: '<%= yeoman.dist %>/images/generated'

      server:
        options:
          debugInfo: true

      dev:
        options:
          debugInfo: true
          sassDir: '<%= yeoman.app %>/styles'
          cssDir: '<%= yeoman.public %>/styles'
          generatedImagesDir: '.tmp/images/generated'
          imagesDir: '<%= yeoman.public %>/images'
          javascriptsDir: '<%= yeoman.public %>/scripts'
          fontsDir: '<%= yeoman.public %>/styles/fonts'
          importPath: './bower_components'
          httpImagesPath: '/images'
          httpGeneratedImagesPath: '/images/generated'
          httpFontsPath: '/styles/fonts'
          relativeAssets: false
          assetCacheBuster: false
          raw: 'Sass::Script::Number.precision = 10\n'

      build:
        options:
          debugInfo: false
          sassDir: '<%= yeoman.app %>/styles'
          cssDir: '<%= yeoman.public %>/styles'
          generatedImagesDir: '.tmp/images/generated'
          imagesDir: '<%= yeoman.public %>/images'
          javascriptsDir: '<%= yeoman.public %>/scripts'
          fontsDir: '<%= yeoman.public %>/styles/fonts'
          importPath: './bower_components'
          httpImagesPath: '/images'
          httpGeneratedImagesPath: '/images/generated'
          httpFontsPath: '/styles/fonts'
          relativeAssets: false
          assetCacheBuster: false
          raw: 'Sass::Script::Number.precision = 10\n'


    # Renames files for browser caching purposes
    filerev:
      dist:
        src: [
          '<%= yeoman.dist %>/scripts/**/*.js'
          '<%= yeoman.dist %>/styles/{,*/}*.css'
          # '<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
          '<%= yeoman.dist %>/styles/fonts/*'
        ]


    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: '<%= yeoman.app %>/layout.phtml'
      options:
        dest: '<%= yeoman.dist %>'
        flow:
          html:
            steps:
              js: [
                'concat'
                'uglifyjs'
              ]
              css: ['cssmin']

            post: {}


    # Performs rewrites based on filerev and the useminPrepare configuration
    usemin:
      html: ['<%= yeoman.dist %>/{,*/}*.phtml']
      css: ['<%= yeoman.dist %>/styles/{,*/}*.css']
      options:
        assetsDirs: [
          '<%= yeoman.dist %>'
          '<%= yeoman.dist %>/images'
        ]


    # The following *-min tasks will produce minified files in the dist folder
    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/styles/main.css': [
    #         '.tmp/styles/{,*/}*.css'
    #       ]
    #     }
    #   }
    # },
    # uglify: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/scripts/scripts.js': [
    #         '<%= yeoman.dist %>/scripts/scripts.js'
    #       ]
    #     }
    #   }
    # },
    # concat: {
    #   dist: {}
    # },
    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg,gif}'
          dest: '<%= yeoman.dist %>/images'
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.svg'
          dest: '<%= yeoman.dist %>/images'
        ]

    htmlmin:
      dist:
        options:
          collapseWhitespace: true
          conservativeCollapse: true
          collapseBooleanAttributes: true
          removeCommentsFromCDATA: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: '<%= yeoman.dist %>'
          src: [
            'layout.phtml'
            '**/*.html'
          ]
          dest: '<%= yeoman.dist %>'
        ]


    # ng-annotate tries to make the code safe for minification automatically
    # by using the Angular long form for dependency injection.
    ngAnnotate:
      dist:
        files: [
          expand: true
          cwd: '.tmp/concat/scripts'
          src: [
            '*.js'
            '!oldieshim.js'
          ]
          dest: '.tmp/concat/scripts'
        ]


    # Replace Google CDN references
    cdnify:
      dist:
        html: ['<%= yeoman.dist %>/*.phtml']


    # Copies remaining files to places other tasks can use
    copy:
      public:
        files: [
          {
            expand: true
            dot: true
            cwd: '<%= yeoman.app %>'
            dest: '<%= yeoman.public %>/'
            src: [
              'scripts/ui-templates.js'
              'scripts/ui-multiselect.js'
              'scripts/marketplace-templates.js'
              'styles/**/*.css'
              'styles/**/*.{css,eot,svg,ttf,woff}'
              'scripts/**/*.{js,html}'
              'index.php'
              'images/**/*'
              '.htaccess'
            ]
          }
        ]
      favicons:
        files: [
          flatten: true
          expand: true
          filter: 'isFile'
          src: '<%= yeoman.app %>/favicons/*'
          dest: '<%= yeoman.public %>/'
        ]
      layout:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>'
          dest: '<%= yeoman.layout %>/'
          src: 'layout.phtml'
        ]
      index:
        files: [
          expand: true
          dot: true
          cwd: '<%= yeoman.app %>'
          dest: '<%= yeoman.index %>/'
          src: 'index.phtml'
        ]
      bowercopy:
        files: [
          expand: true
          src: '<%= yeoman.bower %>/**/*'
          dest: '<%= yeoman.public %>/'
        ]
      dev:
        files: [
          {
            expand: true
            dot: true
            cwd: '<%= yeoman.app %>'
            dest: '.tmp/'
            src: [
              'scripts/ui-templates.js'
              'scripts/ui-multiselect.js'
              'scripts/marketplace-templates.js'
              'scripts/**/*.html'
              'styles/**/*.css'
              'styles/**/*.{css,eot,svg,ttf,woff}'
            ]
          }
          {
            expand: true
            cwd: '.'
            src: 'bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*'
            dest: '<%= yeoman.public %>'
          }
        ]
      build:
        files: [
          {
            expand: true
            cwd: '<%= yeoman.dist %>'
            src: 'layout.phtml'
            dest: '<%= yeoman.layout %>/'
          }
          {
            expand: true
            cwd: '<%= yeoman.dist %>'
            src: 'index.phtml'
            dest: '<%= yeoman.index %>/'
          }
          {
            expand: true
            filter: 'isFile'
            cwd: '<%= yeoman.app %>/'
            src: 'styles/fonts/*'
            dest: '<%= yeoman.public %>/'
          }
          {
            flatten: true
            expand: true
            filter: 'isFile'
            src: '<%= yeoman.app %>/favicons/*'
            dest: '<%= yeoman.public %>/'
          }
          {
            expand: true
            cwd: '<%= yeoman.dist %>/'
            src: [
              '**'
              '!layout.phtml'
              '!index.phtml'
              '!index.html'
              '!**/bower_components/**'
            ]
            dest: '<%= yeoman.public %>/'
          }
        ]
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: '<%= yeoman.app %>'
            dest: '<%= yeoman.dist %>'
            src: [
              '*.{ico,png,txt}'
              '.htaccess'
              '*.html'
              '*.php'
              '*.phtml'
              'images/{,*/}*.{webp}'
              'fonts/{,*/}*.*'
              'scripts/ui-templates.js'
              'scripts/ui-multiselect.js'
              'scripts/marketplace-templates.js'
              'styles/**/*.css'
              'styles/**/*.{css,eot,svg,ttf,woff}'
              'scripts/**/*.{js,html}'
              'index.php'
              'images/**/*'
              '.htaccess'
            ]
          }
          {
            expand: true
            cwd: '.tmp/images'
            dest: '<%= yeoman.dist %>/images'
            src: ['generated/*']
          }
          {
            expand: true
            cwd: '.'
            src: 'bower_components/bootstrap-sass-official/assets/fonts/bootstrap/*'
            dest: '<%= yeoman.dist %>'
          }
        ]

      styles:
        expand: true
        cwd: '<%= yeoman.app %>/styles'
        dest: '.tmp/styles/'
        src: '{,*/}*.css'


    bowercopy:
      # options:
      #   clean: true

      all:
        options:
          destPrefix: '<%= yeoman.public %>/bower_components'
        files:
          'es5-shim/es5-shim.js': 'es5-shim/es5-shim.js'
          'json3/lib/json3.js': 'json3/lib/json3.js'
          'jquery/dist/jquery.js': 'jquery/dist/jquery.js'
          'angular/angular.js': 'angular/angular.js'
          'angular-animate/angular-animate.js': 'angular-animate/angular-animate.js'
          'angular-aria/angular-aria.js': 'angular-aria/angular-aria.js'
          'angular-cookies/angular-cookies.js' :'angular-cookies/angular-cookies.js'
          'angular-messages/angular-messages.js': 'angular-messages/angular-messages.js'
          'angular-resource/angular-resource.js': 'angular-resource/angular-resource.js'
          'angular-route/angular-route.js': 'angular-route/angular-route.js'
          'angular-sanitize/angular-sanitize.js': 'angular-sanitize/angular-sanitize.js'
          'angular-touch/angular-touch.js': 'angular-touch/angular-touch.js'
          # 'moment/moment.js': 'moment/moment.js'
          'angular-bootstrap/ui-bootstrap-tpls.js': 'angular-bootstrap/ui-bootstrap-tpls.js'
          'angular-i18n/angular-locale_pt-br.js': 'angular-i18n/angular-locale_pt-br.js'
          'angular-local-storage/dist/angular-local-storage.js': 'angular-local-storage/dist/angular-local-storage.js'

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        'coffee:dist'
        'compass:server'
      ]
      test: [
        'coffee'
        'compass'
      ]
      dist: [
        'coffee:dev'
        'compass:build'
        'imagemin'
        'svgmin'
      ]
      build: [
        'coffee:dev'
        'compass:build'
        'imagemin'
        'svgmin'
      ]
      dev: [
        'coffee:dev'
        'compass:dev'
      ]


    # Test settings
    karma:
      unit:
        configFile: 'test/karma.conf.coffee'
        singleRun: true

  grunt.registerTask 'serve', 'Compile then start a connect web server', (target) ->
    if target is 'dist'
      return grunt.task.run([
        'build'
        'connect:dist:keepalive'
      ])
    grunt.task.run [
      'clean:server'
      'html2js:bootstrap'
      'html2js:marketplace'
      'wiredep'
      'concurrent:server'
      'autoprefixer'
      'copy:dev'
      # 'connect:livereload'
      'watch'
    ]
    return

  grunt.registerTask 'dev', 'Essa tarefa deve ser usada para desenvolvimento apenas. Compila CoffeeScript, Sass (SCSS) e os copia nos caminhos necessarios em public (js/css/fonts/images). Execute "grunt build (ou publish ou deploy)" para enviar para deploy. Atenção: a tarefa "watch" fica executando (esperando modificação de arquivo para auto compilação). Para sair, pressione ctrl+x.', ->
    grunt.task.run [
      'clean:public'
      'clean:layout'
      'clean:index'
      'html2js:bootstrap'
      'html2js:marketplace'
      'html2js:multiselect'
      'wiredep'
      'concurrent:dev'
      'autoprefixer:dev'
      'copy:public'
      'copy:layout'
      'copy:index'
      'copy:favicons'
      'copy:bowercopy'
      # 'bowercopy'
      'watch'
    ]

  grunt.registerTask 'back', 'Essa tarefa deve ser usada para desenvolvimento apenas. Faz as coisas do Frontend ficarem no lugar deles. Ideal para Backend.', ->
    grunt.task.run [
      'clean:public'
      'clean:layout'
      'clean:index'
      'html2js:bootstrap'
      'html2js:marketplace'
      'wiredep'
      'concurrent:dev'
      'autoprefixer:dev'
      'copy:public'
      'copy:layout'
      'copy:index'
      'copy:favicons'
      'copy:bowercopy'
    ]

  grunt.registerTask 'server', 'DEPRECATED TASK. Use the "serve" task instead', (target) ->
    grunt.log.warn 'The `server` task has been deprecated. Use `grunt serve` to start a server.'
    grunt.task.run ['serve:' + target]
    return

  grunt.registerTask 'test', [
    'clean:server'
    'concurrent:test'
    'autoprefixer'
    'connect:test'
    'karma'
  ]

  grunt.registerTask 'build', ->
    grunt.log.oklns 'Essa tarefa é para construir os arquivos em /public e as views do módulo Direct (layout / index). Para desenvolvimento, use a tarefa "grunt dev".'
    grunt.log.subhead 'OBS - Essa tarefa apaga os diretórios de destino antes de compilar os arquivos'
    try
      grunt.task.run [
        'clean:public'
        'clean:dist'
        'clean:layout'
        'clean:index'
        'html2js:bootstrap'
        'html2js:marketplace'
        'html2js:multiselect'
        'wiredep'
        'useminPrepare'
        'concurrent:dist'
        'autoprefixer:dist'
        'concat'
        'ngAnnotate'
        'copy:dist'
        #'cdnify'
        'cssmin'
        'uglify'
        'filerev'
        'usemin'
        'htmlmin'
        'copy:build'
      ]
      grunt.verbose.ok()
    catch e
      grunt.verbose.or.write().error().error(e.message);
      grunt.fail.warn 'Algo deu errado! Veja o erro acima.'


  grunt.registerTask 'publish', (target) ->
    grunt.log.oklns 'Esse comando é só um alias para "grunt build"'
    grunt.task.run ['build:' + target]

  grunt.registerTask 'deploy', (target) ->
    grunt.log.oklns 'Esse comando é só um alias para "grunt build"'
    grunt.task.run ['build:' + target]

  grunt.registerTask 'backend', (target) ->
    grunt.log.oklns 'Esse comando é só um alias para "grunt back"'
    grunt.task.run ['back:' + target]

  grunt.registerTask 'be', (target) ->
    grunt.log.oklns 'Esse comando é só um alias para "grunt back"'
    grunt.task.run ['back:' + target]

  grunt.registerTask 'default', [
    'newer:jshint'
    'test'
    'build'
  ]
  return
