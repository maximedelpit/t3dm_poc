$(document).ready(function() {
  $('select').material_select();
  $('ul.tabs').trigger('tab_change', function(e){
  });
  $('.tooltipped').tooltip({delay: 200});
});

