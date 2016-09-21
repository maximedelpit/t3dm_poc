function drop_handler(ev) {
  console.log("Drop");
  var parent = $(ev.currentTarget).parent();
  parent.removeClass('dragging-in');
}

function dragover_handler(ev) {
  console.log("dragOver");

  // Prevent default select and drag behavior
  ev.preventDefault();
  ev.dataTransfer.dropEffect = "copy";
  var parent = $(ev.currentTarget).parent();
  parent.addClass('dragging-in');
}

function dragleave_handler(ev) {
  console.log("dragOver");

  // Prevent default select and drag behavior
  ev.preventDefault();
  var parent = $(ev.currentTarget).parent();
  parent.removeClass('dragging-in');
}
