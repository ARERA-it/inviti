class UserInteractionsController
  init: ->

  index: ->
    $('table.ui-cal td.ui-cell').on('click', ->
      url = $(this).data('url')
      if url!=""
        $.get(url)
    )

this.App.user_interactions = new UserInteractionsController
