var gulp = require('gulp');
var browserify = require('browserify');
var source = require("vinyl-source-stream");
var reactify = require("reactify");

gulp.task("bundle", function () {
  browserify({
    entries: "./src/js/app.js",
    debug: true,
    standalone: "App"
  })
    .transform(reactify)
    .bundle()
    .pipe(source("bundle.js"))
    .pipe(gulp.dest("./dist"));
});

gulp.task("watch", function () {
  gulp.watch("src/**/*.js", ["default"]);
});

gulp.task("default", ["bundle"]);
