class PagesController
  init: ->

  dashboard: ->
    $('ul.sidebar li.nav-item.dashboard').each (el) ->
      $(this).addClass('active')

    $('.dashboard-cards .card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )


    # $('.dismiss-btn').on('click', ->
    #   url = $(this).data('url')
    #   if url!=""
    #     $.post(url).done ->
    #       alert("hello!")
    # )

this.App.pages = new PagesController
