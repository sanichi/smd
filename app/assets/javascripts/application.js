// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require clipboard

// click controls
function select_work(num) {
  $(".work").hide();
  $("#work" + num).show();
  $(".selector").removeClass("selected");
  $("#selector" + num).addClass("selected");
  $("#num").text(num);
}

// keyboard controls
$(window).keydown(function (e) {
  switch (e.keyCode) {
    case 39: // right arrow
      select_next(1);
      break;
    case 37: // left arrow
      select_next(-1);
      break;
  }
});

// keyboard and button controls
function select_next(delta) {
  var id = $('.selector.selected').attr('id');
  if (id) {
    var match = id.match(/[1-9]\d*/);
    if (match) {
      num = parseInt(match[0]) + delta;
      var total = $('.selector').length;
      num = num > total ? 1 : num;
      num = num < 1 ? total : num;
      select_work(num);
    }
  }
}

$(function () {
  // Auto-submit on change.
  $('form .auto-submit').change(function () {
    $(this).parents('form').submit();
  });
});
