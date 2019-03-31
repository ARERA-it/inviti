//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require sb-admin
//= require jquery.easing

// Autocomplete feature:
//= require jquery-ui
//= require autocomplete-rails


//= require moment
//= require moment/it
//= require livestamp
//= require moment-timezone-with-data
//= require tempusdominus-bootstrap-4

//= require init
//= require invitations
//= require accepts

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


jQuery.railsAutocomplete.options.noMatchesLabel = "Nessun nominativo trovato";
