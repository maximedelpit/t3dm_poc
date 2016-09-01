$(document).ready(function() {
  setTimeout(function() { $('.alert').slideUp()}, 3000);

  $('.close-box').click(function(event) {
    $(this).parent('#instructions').slideUp();
  })
});
