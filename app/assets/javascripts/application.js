//= require rails-ujs
//= require activestorage
//= require turbolinks

//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require sb-admin-2
//= require jquery.easing

// Autocomplete feature:
//= require jquery-ui
//= require autocomplete-rails

//= require jquery.dataTables
//= require dataTables.bootstrap4

//= require moment
//= require moment/it
//= require livestamp
//= require moment-timezone-with-data
//= require tempusdominus-bootstrap-4

//= require init
//= require invitations
//= require accepts
//= require pages
//= require helper-functions

datatableItalian = {
  "sEmptyTable":     "Nessun dato presente nella tabella",
  "sInfo":           "Vista da _START_ a _END_ di _TOTAL_ elementi",
  "sInfoEmpty":      "Vista da 0 a 0 di 0 elementi",
  "sInfoFiltered":   "(filtrati da _MAX_ elementi totali)",
  "sInfoPostFix":    "",
  "sInfoThousands":  ".",
  "sLengthMenu":     "Visualizza _MENU_ elementi",
  "sLoadingRecords": "Caricamento...",
  "sProcessing":     "Elaborazione...",
  "sSearch":         "Cerca:",
  "sZeroRecords":    "La ricerca non ha portato alcun risultato.",
  "oPaginate": {
    "sFirst":      "Inizio",
    "sPrevious":   "Precedente",
    "sNext":       "Successivo",
    "sLast":       "Fine"
  },
  "oAria": {
    "sSortAscending":  ": attiva per ordinare la colonna in ordine crescente",
    "sSortDescending": ": attiva per ordinare la colonna in ordine decrescente"
  }
}


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



  // Toggle the side navigation
  $("#sidebarToggle, #sidebarToggleTop").on('click', function(e) {
    $("body").toggleClass("sidebar-toggled");
    $(".sidebar").toggleClass("toggled");
    if ($(".sidebar").hasClass("toggled")) {
      $('.sidebar .collapse').collapse('hide');
    };
  });

  $('#dataTable').DataTable({
      "pageLength": 50,
      "language": datatableItalian,
      "order": [[ 1, "asc" ]],
      "columnDefs": [
        {
          "orderData": [ 2 ],
          "targets": 1
        },
        {
          "targets": [ 2 ],
          "visible": false,
          "searchable": false
        },
        {
          "targets": [ 3 ],
          "visible": false,
          "searchable": true
        }

      ]
    });

});


jQuery.railsAutocomplete.options.noMatchesLabel = "Nessun nominativo trovato";
