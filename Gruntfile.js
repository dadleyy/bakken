var grunt = require('grunt'),
    dotenv = require('dotenv'),
    btoa = require('btoa');

module.exports = function() {

  dotenv.load();

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-angular-templates');
  grunt.loadNpmTasks('grunt-smash');
  grunt.loadTasks('tasks');

  function jadeFiles(srcdir, destdir, wildcard) {
    var path = require('path'),
        files = {};

    grunt.file.expand({cwd: srcdir}, wildcard).forEach(function(relpath) {
      destname = relpath.replace(/\.jade$/ig,'.html');
      files[path.join(destdir, destname)] = path.join(srcdir, relpath);
    });

    return files;
  };

  grunt.initConfig({

    clean: {
      all: [
        'obj', 
        'public/js', 
        'public/css', 
        'public/index.html',
      ]
    },

    coffee: {
      src: {
        options: {
          bare: true,
          join: true
        },
        files: {
          'obj/js/app.js': [
            'bower_components/waveform/views/waveform.coffee',
            'src/coffee/module.coffee', 
            'src/coffee/**/*.coffee'
          ]
        }
      }
    },

    jade: {
      debug: {
        options: {
          data: {
            debug: true
          }
        },
        files: jadeFiles('src/jade', 'obj/html', '**/*.jade')
      },
      release: {
        options: {
          data: {
            debug: false
          }
        },
        files: {
          'public/index.html': 'src/jade/index.jade'
        }
      }
    },

    ngtemplates: {
      build: {
        src: ['obj/html/directives/*.html', 'obj/html/views/*.html'],
        dest: 'obj/js/templates.js',
        options: {
          module: 'bakken',
          url: function(url) { 
            return url.replace(/^obj\/html\/(.*)\/(.*)\.html$/,'$1.$2');
          }
        }
      }
    },

    smash: {
      build: {
        src: "build.js",
        dest: "public/js/app.js"
      }
    },

    copy: {
      svg: {
        expand: true,
        cwd: 'src/svg',
        src: '**/*.svg',
        dest: 'public/svg'
      },
      index: {
        files: [{
          expand: true,
          cwd: 'obj/html',
          src: 'index.html',
          dest: 'public/'
        }]
      }
    },

    watch: {
      svg: {
        files: ['src/svg/*.svg'],
        tasks: ['copy:svg']
      },
      scripts: {
        files: ['src/coffee/**/*.coffee'],
        tasks: ['coffee', 'smash']
      },
      templates: {
        files: ['src/jade/**/*.jade'],
        tasks: ['jade:debug', 'copy:index', 'ngtemplates', 'smash']
      },
      sass: {
        files: ['src/sass/**/*.sass'],
        tasks: ['sass']
      }
    },

    sass: {
      build: {
        options: {
          loadPath: require('node-neat').includePaths
        },
        files: {
          'public/css/app.css': 'src/sass/app.sass'
        }
      }
    },

    keyfile: {
      soundcloud: {
        dest: "obj/js/soundcloud.js",
        module: "bakken",
        name: "SAK",
        key: btoa(process.env['SOUNDCLOUD_KEY'])
      },
      google: {
        dest: 'obj/js/google.js',
        module: false,
        name: 'GOOGLE_ANALYTICS',
        key: btoa(process.env['GOOGLE_ANALYTICS'])
      }
    },

    uglify: {
      release: {
        files: {
          'public/js/app.min.js': ['public/js/app.js']
        }
      }
    }

  });
  
  grunt.registerTask('js', ['coffee', 'jade:debug', 'ngtemplates', 'keyfile', 'smash']);
  grunt.registerTask('css', ['sass']);
  grunt.registerTask('default', ['css', 'coffee', 'js', 'css', 'copy']);
  grunt.registerTask('release', ['default', 'jade:release', 'uglify']);

};
