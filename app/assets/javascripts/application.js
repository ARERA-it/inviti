//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require sb-admin
//= require jquery.easing

//= require moment
//= require moment/it
//= require livestamp
//= require tempusdominus-bootstrap-4

//= require init
//= require invitations

//= require helper-functions

$(document).on("turbolinks:load", function() {
  var $body = $("body")
  var controller = $body.data("controller").replace(/\//g, "_");
  var action = $body.data("action");

  // console.log("controller: "+controller);
  // console.log("action: "+action);
  var activeController = App[controller];
  if (activeController !== undefined) {
    if ($.isFunction(activeController.init)) {
      activeController.init();
    }
    if ($.isFunction(activeController[action])) {
      activeController[action]();
    }
  }

});
