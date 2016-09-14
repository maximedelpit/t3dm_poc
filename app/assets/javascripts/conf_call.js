$(document).ready(function() {
  $('.launch-conf').click(function(event) {
    var room_url = "https://appear.in/" + $(this).data('room-name')
    conf_iframe = '<iframe src=' + room_url + 'class="responsive-img materialboxed" width="100%" height="430px" frameborder="0"></iframe>'
    $('#pending-call .conf-part').html(conf_iframe);
    $('#pending-call').openModal()
  });
});
