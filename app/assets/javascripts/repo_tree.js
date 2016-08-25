// For right click upload https://groups.google.com/forum/#!topic/jstree/YknwUl31XIo
function init_tree(tree) {
    tree.jstree({
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

    // // register tree_moves => probably disable this...
    // tree.on('move_node.jstree', function (e, data) {
    //   console.log('MOVING!');
    // });
  };



function monitor_tree_input_change(input_trees) {
  input_trees.on('change',function(event){
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
  });
}

$(document).ready(function() {
  var $JStree_repo = $('#jstree')
  init_tree($JStree_repo);
  monitor_tree_input_change($('.input-tree'));
});
