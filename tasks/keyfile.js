module.exports = function(grunt) {

  grunt.registerMultiTask('keyfile', 'creates a keyfile for angular', function() {
    var keyfile = this.data['dest'],
        module = this.data['module'],
        name = this.data['name'],
        generator = this.data['generator'],
        key = this.data['key'] || generator();

    function contentGen() {
      return ["angular.module(\"", module, "\").value(\"", name ,"\", (function(a){ return atob(a); })(\"", key, "\"));"].join('');
    };

    grunt.file.write(keyfile, contentGen(key));

    grunt.log.ok("created " + keyfile);
  });

};
