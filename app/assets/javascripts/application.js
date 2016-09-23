//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require materialize-sprockets
//= require materialize-form
//= require jstree
//= require sweetalert2
//= require clockpicker
//= require cocoon
//= require Chart-js
//= require_tree .


function ajax_resize() {
  $('.panel-container').css({
      height: $(".panel.core").height()
  });
  $('.panel-container .panel.core .row').css({
      height: $(".panel.core").height()
  });
}
