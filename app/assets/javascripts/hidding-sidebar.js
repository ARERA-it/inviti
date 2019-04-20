// Toggle the side navigation
function toggleSidebar() {
  $("body").toggleClass("sidebar-toggled");
  $(".sidebar").toggleClass("toggled");
  if ($(".sidebar").hasClass("toggled")) {
    $('.sidebar .collapse').collapse('hide');
  };
}
function hideSidebar() {
  if (!$('body').hasClass("sidebar-toggled")) {
    $("body").addClass("sidebar-toggled");
  }
  if (!$(".sidebar").hasClass("toggled")) {
    $(".sidebar").addClass("toggled");
  } else {
    $('.sidebar .collapse').collapse('hide');
  };
}
function showSidebar() {
  if ($('body').hasClass("sidebar-toggled")) {
    $("body").removeClass("sidebar-toggled");
  }
  if ($(".sidebar").hasClass("toggled")) {
    $(".sidebar").removeClass("toggled");
  } else {
    $('.sidebar .collapse').collapse('hide');
  };
}
