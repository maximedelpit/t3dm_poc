$(document).ready(function() {
  // $('.attachinary-input').attachinary();
  $('.attachinary-input').on('change', function(e) {
    $('.attchachinary-filename').text($(this).val().replace("C:\\fakepath\\",''));
  });
});
