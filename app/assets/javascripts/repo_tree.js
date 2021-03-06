// For right click upload https://groups.google.com/forum/#!topic/jstree/YknwUl31XIo
// http://stackoverflow.com/questions/23060840/expand-jstree-node-when-parent-is-clicked
// https://gist.github.com/pontikis/1097570
function init_tree(tree) {
  tree.on("select_node.jstree", function (event, data) {
    if (data.node.data.gtype === 'blob') {
      var sha = data.node.data.sha;
      var path = data.node.data.path;
      var project_id = data.node.data.project;
      var url = project_id + '/file/' + sha + '?path=' + path;
      console.log(path + ' - ' + sha);
      $.get( url, null, function(data,status,xhr) {}, 'script');
    } else if (data.node.data.gtype === 'tree') {
      if (data.node.state.opened) {
        tree.jstree("close_node", $("#"+data.node.id));
      } else {
        tree.jstree("open_node", $("#"+data.node.id));
      }
    }
  }).jstree({
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
      },
      "disabled": {
          "select_node": false,
          "open_node":   false,
          "close_node":  false,
          "create_node": false,
          "delete_node": false
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
        text: 'Please confirm upload or cancel',
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#00899d',
        cancelButtonColor: '#ababab',
        showLoaderOnConfirm: true,
        confirmButtonText: 'Upload',
        onClose: function(event) {
          var btn = $(event);
          if (btn.hasClass('loading')) {
            $(event).toggleClass('hide-swal2')  ;
          } else {
            $('.jstree-form .clean-input').each(function(index){
              $(this).attr('disabled', false);
              $(this).val('');
            });
          }
        }
      }).then(function(result) {
        $('#pull_request').val(false);
        $('.jstree-form').submit();
        // swal({
        //   type: 'success',
        //   html: 'You entered: ' + result
        // });
        }, function(dismiss) {
          if ($.inArray(dismiss, ['cancel', 'overlay', 'close']) > -1) {
            $('.jstree-form .clean-input').each(function(index){
              $(this).attr('disabled', false);
              $(this).val('');
            });
          }
        })



      // swal({
      //   title: title,
      //   text: "Type DIRECT for direct upload \n Or TEAM if you your team to discuss within a topic.",
      //   input: 'text',
      //   inputPlaceholder: "Type TEAM or DIRECT",
      //   showCancelButton: true,
      //   animation: "slide-from-top",
      //   inputValidator: function(value) {
      //     return new Promise(function(resolve, reject) {
      //       if (value === 'TEAM') {
      //         $('#pull_request').val(true);
      //         swal.close();
      //         $('#pr_fields').openModal({
      //           complete: function() {
      //             // make conditions
      //             $('.jstree-form').submit();
      //           }
      //         });
      //       } else if (value === 'DIRECT') {
      //         $('#pull_request').val(false);
      //         swal.close();
      //         $('.jstree-form').submit(); //utils.js:70 Uncaught TypeError: $.rails.ajax(...).complete is not a function
      //       } else {
      //         reject('You can only write TEAM or DIRECT (capitalized)!');
      //       }
      //     });
      //   }
      // }).then(function(result) {
      //   swal({
      //     type: 'success',
      //     html: 'You entered: ' + result
      //   });
      //   }, function(dismiss) {
      //     if ($.inArray(dismiss, ['cancel', 'overlay', 'close']) > -1) {
      //       $('.jstree-form .clean-input').each(function(index){
      //         $(this).attr('disabled', false);
      //         $(this).val('');
      //         console.log($(this).attr('id') +'---'+ $(this).val() +'---'+$(this).attr('disabled') )
      //       });
      //     }
      //   })
    }
  });
}

$(document).ready(function() {
  var $JStree_repo = $('#jstree')
  init_tree($JStree_repo);
  monitor_tree_input_change($('.input-tree'));
});


// $("#jstree").bind("select_node.jstree", function (event, data) {

//         // open all unopened parents of the selected node (OPTIONAL)
//         data.rslt.obj.parents('.jstree-closed').each(function () {
//             data.inst.open_node(this);
//         });

//         var node_id = data.rslt.obj.attr("id");

//         // do something
// });

$('#order_data_package').change(function(event){
  $('#jstree').jstree().close_all(null, 200);
  if(this.checked) {
    $('#jstree i.jstree-ocl').off('click.block').on('click.block', function() {
       return false;
    });
    $('#folders form input').each(function(index) {$(this).attr('disabled', true)});
    $('#folders #jstree .jstree-node').each(function(index) {
      $('#jstree').jstree().disable_node(this.id);
      // $(this).data('jstree')
    });
    $('#new_order button').attr('disabled', false);
  } else {
    $('#jstree i.jstree-ocl').off('click.block');
    $('#folders form input').each(function(index) {$(this).attr('disabled', false)});
    $('#folders #jstree .jstree-node').each(function(index) {
      $('#jstree').jstree().enable_node(this.id);
      // $(this).data('jstree')
    });
    $('#new_order button').attr('disabled', true);
  }
});








