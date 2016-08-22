// For right click upload https://groups.google.com/forum/#!topic/jstree/YknwUl31XIo
$(document).ready(function() {
  $(function () {
    var $JStree_repo = $('#jstree').jstree({
      "core" : {
        "multiple" : false,
        "check_callback" : true,
        "themes" : {
          "dots" : false // no connecting dots between dots
        }
      },
      "types" : {
        "default" : {
          "icon" : "fa fa-file"
        },
        "folder" : {
          "icon" : "fa fa-folder"
        },
        "file" : {
          "icon" : "fa fa-file"
        }
      },
      "plugins" : [ "conditionalselect", "contextmenu", "changed", "dnd", "search", "types", "wholerow" ],
    });

    // register tree_moves => probably disable this...
    $JStree_repo.on('move_node.jstree', function (e, data) {
      console.log('MOVING!');
    });

    $('.input-tree').on('change',function(event){
      if ($(this).val() != '') {
        var folder_name = $(this).closest('li').text();
        var data_path = $(this).closest('li').data('path');
        $(this).siblings('.sha-path-input').val(data_path);
        var title = "Upload to" + folder_name;
        swal({
          title: title,
          text: "Type DIRECT for direct upload \n Or TEAM if you your team to discuss within a topic.",
          input: 'text',
          inputPlaceholder: "Type TEAM or DIRECT",
          showCancelButton: true,
          animation: "slide-from-top",
          inputValidator: function(value) {
            return new Promise(function(resolve, reject) {
              if (value === 'TEAM') {
                $('#pull_request').val(true);
                swal.close();
                $('#pr_fields').openModal({
                  complete: function() {
                    // make conditions
                    $('.jstree-form').submit();
                  }
                });
              } else if (value === 'DIRECT') {
                $('#pull_request').val(false);
                swal.close();
                $('.jstree-form').submit(); //utils.js:70 Uncaught TypeError: $.rails.ajax(...).complete is not a function
              } else {
                reject('You can only write TEAM or DIRECT (capitalized)!');
              }
            });
          }
        }).then(function(result) {
          swal({
            type: 'success',
            html: 'You entered: ' + result
          });
          }, function(dismiss) {
            if ($.inArray(dismiss, ['cancel', 'overlay', 'close']) > -1) {
              $('.jstree-form .clean-input').each(function(index){
                $(this).attr('disabled', false);
                $(this).val('');
                console.log($(this).attr('id') +'---'+ $(this).val() +'---'+$(this).attr('disabled') )
              });
            }
          })
      }




      // if ($(this).val() != '') {
      //   var folder_name = $(this).closest('li').text();
      //   var data_path = $(this).closest('li').data('path');
      //   $(this).siblings('.sha-path-input').val(data_path);
      //   swal({
      //       title: "Upload to" + folder_name, type: "question", input: 'text',
      //       text: "Type DIRECT for direct upload \n Or TEAM if you your team to discuss within a topic.",
      //       showCancelButton: true, closeOnConfirm: false, animation: "slide-from-top",
      //       inputPlaceholder: "Type TEAM or DIRECT"
      //     },
      //     function(inputValue){
      //       if (inputValue === false) return false;
      //       if (inputValue != 'TEAM' && inputValue != 'DIRECT' ) {
      //         swal.showInputError("You can only write TEAM or DIRECT (capitalized)!");
      //         return false;
      //       } else if(inputValue === 'TEAM') {
      //         $('#pull_request').val(true);
      //         swal.close();
      //         $('#pr_fields').openModal({
      //           complete: function() {
      //             // make conditions
      //             $('.jstree-form').submit();
      //           }
      //         });
      //       } else {
      //         $('#pull_request').val(false);
      //         swal.close();
      //         $('.jstree-form').submit(); //utils.js:70 Uncaught TypeError: $.rails.ajax(...).complete is not a function
      //       }
      //     }
      //   ).then(function(isConfirm) {debugger;});
      // }
    });
  });
});


