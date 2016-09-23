$(document).ready(function() {
  setTimeout(function() { $('.alert').slideUp()}, 3000);

  $('.close').click(function(event) {
    $(this).parent('#instructions, .alert').slideUp();
  });

  // $('#satisfaction-btn').click(function(event) {
  //   event.preventDefault();
  //   swal({
  //     title: 'Congrats! Hope to see you soon...',
  //     html: $('<div>')
  //       .addClass('giphy-wrapper')
  //       .html('<iframe src="//giphy.com/embed/5wWf7GW1AzV6pF3MaVW" width="432" height="250" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/editingandlayout-the-office-high-five-5wWf7GW1AzV6pF3MaVW">via GIPHY</a></p>')
  //   })
  //   $(this).parent('form').submit();
  // });
});


