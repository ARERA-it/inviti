
function show_toast_alert(message) {
  $('#toast-alert .toast-body').text(message);
  $('#toast-alert').toast('show');
}

function show_toast_notice(message) {
  $('#toast-notice .toast-body').text(message);
  $('#toast-notice').toast('show');
}

function show_toast(kind, message) {
  console.log(kind);
  console.log(message);


  if (kind=='alert' && message!=="") {
    show_toast_alert(message);
  } else {
    show_toast_notice(message);
  }
}


$(document).on("turbolinks:load", function() {

  var flh = $('body').data('flash');
  if (!$.isEmptyObject(flh)) {
    if (flh.hasOwnProperty('notice')) {
      show_toast_notice(flh.notice);
    }
    if (flh.hasOwnProperty('alert')) {
      show_toast_alert(flh.alert);
    }
  }
})
