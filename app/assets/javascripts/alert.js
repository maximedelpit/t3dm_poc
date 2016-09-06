$(document).ready(function() {
  // setTimeout(function() { $('.alert').slideUp()}, 3000);

  $('.close').click(function(event) {
    $(this).parent('#instructions, .alert').slideUp();
  })
});
