$(document).ready(function() {
  $('select').material_select();
  $('ul.tabs').trigger('tab_change', function(e){
  });
  $('.tooltipped').tooltip({delay: 200});



  // Setup base height
  // var resize_element = $('#new_topic').parents('li.collection-item')
  // var btn = $('#topic_content').parents('form').children('.btn')
  // var increase_by = $('#topic_content').outerHeight + btn.outerHeight()
  // // Used to make text area parent to have same size
  // // li.collection-item is a bit restrictive should have a function
  // $('#topic_content').on('keyup', function(e) {
  //   if (e.keyCode == 13) {
  //     var parent = $(this).parents('li.collection-item')
  //     var increase_height = $(this.outerHeight)
  //     var ref_height = parent.outerHeight();
  //     parent.outerHeight(ref_height + form_height);
  //   } else if (e.keyCode == 8) {
  //     var parent = $(this).parents('li.collection-item')
  //     var btn = $('#topic_content').parents('form').children('.btn')
  //     debugger;
  //     var form_height = $(this).parent(parent).outerHeight() + btn.outerHeight()
  //     var ref_height = parent.outerHeight();
  //     parent.outerHeight(ref_height - form_height);
  //   }
  // })

  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 1, // Creates a dropdown of 15 years to control year,
    autoclose: true
  })
  $('.clockpicker').clockpicker({
    autoclose: true
  });


  $('#user_category').on('change', function(event) {
    $(this).parents('form').submit();
  })

  $('.modal-trigger').leanModal({
    ready: function() { Materialize.updateTextFields(); },
    complete: function() { Materialize.updateTextFields(); },
  });

   $('.materialboxed').materialbox();
});
