$('.accordion').click(function(e) {
  if ($(this).hasClass('closed')) {
    $(this).toggleClass('closed');
    $('.accordion.open').toggleClass('open closed');
    $(this).toggleClass('open')
  }
});
