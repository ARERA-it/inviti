class PagesController
  init: ->

  dashboard: ->
    $('ul.sidebar li.nav-item.dashboard').each (el) ->
      $(this).addClass('active')

    $('.dashboard-cards .card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )

this.App.pages = new PagesController
