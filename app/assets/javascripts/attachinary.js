$(document).ready(function() {
  $('.file.attachinary').attachinary();
  $('.attachinary-input').on('change', function(e) {
    $('.attchachinary-filename').text($(this).val().replace("C:\\fakepath\\",''));
  });
});
