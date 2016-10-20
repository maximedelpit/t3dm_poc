$(document).ready(function() {
  $('.launch-conf').click(function(event) {
    $('.url-conf-title').remove();
    var room_url = "https://appear.in/" + $(this).data('room-name')
    conf_iframe = '<iframe src=' + room_url + 'class="responsive-img materialboxed" width="100%" height="600px" frameborder="0"></iframe>'
    $('#pending-call .conf-part').html(conf_iframe);
    $('#pending-call').openModal();
    $('#pending-call .modal-content').prepend('<h3 class="url-conf-title">Please share url with attendees : '+room_url+'</h3>');
  });
});
