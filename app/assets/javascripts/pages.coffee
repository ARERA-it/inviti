class PagesController
  init: ->

  dashboard: ->
    $('ul.sidebar li.nav-item.dashboard').each (el) ->
      $(this).addClass('active')


this.App.pages = new PagesController
