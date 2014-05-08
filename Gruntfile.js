var grunt = require('grunt');

module.exports = function() {

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-angular-templates');
  grunt.loadNpmTasks('grunt-smash');

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
          'obj/js/app.js': ['src/coffee/**/*.coffee']
        }
      }
    },

    jade: {
      debug: {
        files: jadeFiles('src/jade', 'obj/html', '**/*.jade')
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

  });
  
  grunt.registerTask('js', ['coffee', 'jade:debug', 'ngtemplates', 'smash']);
  grunt.registerTask('css', ['sass']);
  grunt.registerTask('default', ['js', 'css', 'copy']);

};
