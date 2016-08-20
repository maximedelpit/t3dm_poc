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
      var folder_name = $(this).closest('li').text();
      var data_path = $(this).closest('li').data('path');
      $(this).siblings('.sha-path-input').val(data_path);
      swal({
          title: "Upload to" + folder_name, type: "input",
          text: "Type DIRECT for direct upload \n Or TEAM if you your team to discuss within a topic.",
          showCancelButton: true, closeOnConfirm: false, animation: "slide-from-top",
          inputPlaceholder: "Write something"
        },
        function(inputValue){
          if (inputValue === false) return false;
          if (inputValue != 'TEAM' && inputValue != 'DIRECT' ) { swal.showInputError("You can only write TEAM or DIRECT (capitalized)!"); return false }
          swal.close();
          $('.jstree-form').submit(); //utils.js:70 Uncaught TypeError: $.rails.ajax(...).complete is not a function
        }
      );
    });
  });
});


