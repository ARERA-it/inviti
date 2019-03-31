# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class InvitationsController
  init: ->

  index: ->
    $('.inv-card').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )

    $('.cal-event').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )


    $('ul.sidebar li.nav-item').each (el) ->
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

    # $('#invitation_appointee_id').on('change', ->
    #   InvitationsController.manage_dropdown()
    # )
    # InvitationsController.manage_dropdown()
    # if $('#invitation_alt_appointee_name').val()!=''
    #   $('#invitation_appointee_id').val("0")

    $('#invitation_decision').on('change', ->
      InvitationsController.manage_participation()
    )
    InvitationsController.manage_participation()



  # @manage_dropdown: ->
  #   val = $('#invitation_appointee_id').val()
  #   # console.log val
  #   # console.log "-- disabled: #{val!='0'}"
  #   if val=='0'
  #     # 'Altro'
  #     # $("#invitation_alt_appointee_name").prop('disabled', false)
  #   else
  #     $("#invitation_alt_appointee_name").prop('disabled', true)
  #     $('#invitation_alt_appointee_name').val('')



  @manage_participation: ->
    val = $('#invitation_decision').val()
    if val=='participate'
      # $('.who-participates').show()
      $('.who-participates').removeClass('d-none')
    else
      # $('.who-participates').hide()
      $('.who-participates').addClass('d-none')

this.App.invitations = new InvitationsController
