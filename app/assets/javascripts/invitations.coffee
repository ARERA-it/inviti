class InvitationsController
  init: ->

  index: ->
    $('.archive-btn').on('click', (e) ->
      console.log "archive!"
      id = $(this).parents('.inv-card').first().data('id')
      if id
        console.log id
        options = {}
        # $('#confirm-archive-modal').data('foo', id)
        $('#modal-submit-btn').attr('href', "/invitations/#{id}")
        $('#confirm-archive-modal').modal(options)



      e.stopPropagation()
    )

    $('.inv-card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )

    $('.cal-event').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )

    # highlight selected item on sidebar
    $('ul.sidebar li.nav-item').each (el) ->
      console.log "1"
      filter = getUrlParameter('sel')
      if $(this).hasClass(filter)
        $(this).addClass('active')


    $('.vis-mode-selector').on('click', ->
      v = $(this).find('input').val()
      $.ajax('/settings/update', method: 'get', data: { vis_mode: v}).done( ->
        console.log location.toString()
        Turbolinks.visit(location.toString());
      ).always( ->
        console.log "always"

      )
    )

    $('table.record-list tr.clickable').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )


  show: ->
    $('#invitation-from-date-time').datetimepicker({format: 'DD-MM-YYYY HH:mm', locale: 'it'})
    $('#invitation-to-date-time').datetimepicker({format: 'DD-MM-YYYY HH:mm', locale: 'it'})
    $('#button-copy-email-subject').on('click', -> $('#invitation_title').val($('#email-subject').text()) )


    wtf = $('.panel-chat')
    if wtf[0]
      height = wtf[0].scrollHeight
      wtf.scrollTop(height)


    $('#invitation_decision').on('change', ->
      InvitationsController.manage_participation()
    )
    InvitationsController.manage_participation()



  @manage_participation: ->
    val = $('#invitation_decision').val()
    if val=='participate'
      # $('.who-participates').show()
      $('.who-participates').removeClass('d-none')
    else
      # $('.who-participates').hide()
      $('.who-participates').addClass('d-none')

this.App.invitations = new InvitationsController
