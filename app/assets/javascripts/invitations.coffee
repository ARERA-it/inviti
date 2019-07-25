class InvitationsController
  init: ->

  index: ->
    $('.archive-btn').on('click', (e) ->
      id = $(this).parents('.inv-card').first().data('id')
      if id
        options = {}
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
      filter = getUrlParameter('sel')
      if $(this).hasClass(filter)
        $(this).addClass('active')


    $('.vis-mode-selector').on('click', ->
      v = $(this).find('input').val()
      $.ajax('/settings/update', method: 'get', data: { vis_mode: v}).done( ->
        Turbolinks.visit(location.toString());
      )
      # .always( ->
      #   console.log "always"
      # )
    )

    $('table.record-list tr.clickable').on('click', ->
      url = $(this).data('url')
      Turbolinks.visit(url)
    )



  show: ->
    $('#invitation-from-date-time').datetimepicker({format: 'DD-MM-YYYY HH:mm', locale: 'it'})
    $('#invitation-to-date-time').datetimepicker({format: 'DD-MM-YYYY HH:mm', locale: 'it'})
    $('#button-copy-email-subject').on('click', -> $('#invitation_title').val($('#email-subject').text()) )

    $('#invitation-from-date-time').on('focusout', ->
      if $('#invitation_from_date_and_time_view').val()!="" && ($('#invitation_to_date_and_time_view').val()=="" || $('#invitation_to_date_and_time_view').val()=="Invalid date")
        m = moment($('#invitation_from_date_and_time_view').val(), 'DD-MM-YYYY HH:mm')
        m.add(2, 'h') # add 2 hours
        $('#invitation_to_date_and_time_view').val(m.format('DD-MM-YYYY HH:mm'))
    )

    pc = $('.panel-chat')
    if pc[0]
      height = pc[0].scrollHeight
      pc.scrollTop(height)


    $('#invitation_decision').on('change', ->
      InvitationsController.manage_participation()
    )
    InvitationsController.manage_participation()


    $('.assignment-step-modal').on('click', (e) ->
      c = $(this).data('comment')
      $('#assignment_step_msg p.comment-here').html(c)
      $('#assignment_step_msg').modal('show')
    )

    this.register_open_app_modal_btn()
    # Open edit-appointee modal
    # $('.open-edit-appointee-modal').on('click', (e) ->
    #   $('#edit-appointee-modal').modal('show')
    #   console.log $(this).text()
    #   $('#edit-appointee-modal #appointee_user_display_name').val($(this).text())
    #   e.stopPropagation()
    # )



  register_open_app_modal_btn: ->
    $('.open-edit-appointee-modal-btn').on('click', (e) ->
      user_display_name = $(this).data('name')
      selected_id       = $(this).data('user-id')
      url               = $(this).data('url')

      $.get(url).done( ->
        $('#edit-appointee-modal').modal('show')

        $('#edit-appointee-modal #appointee_user_display_name').val(user_display_name)
        $('#edit-appointee-modal #appointee_selected_id').val(selected_id)
        $('#edit-appointee-modal #appointee_user_or_group').val("user")
      )
      e.stopPropagation()
    )

  @set_participation_buttons: ->
    response = $('#invitation_decision').val()
    if response=="participate"
      $('#participate-yes').removeClass('btn-outline-success')
      $('#participate-yes').addClass('btn-success')
      $('#participate-no').removeClass('btn-danger')
      $('#participate-no').addClass('btn-outline-danger')
    else if response=="do_not_participate"
      $('#participate-yes').removeClass('btn-success')
      $('#participate-yes').addClass('btn-outline-success')
      $('#participate-no').removeClass('btn-outline-danger')
      $('#participate-no').addClass('btn-danger')
    else
      $('#participate-yes').removeClass('btn-success')
      $('#participate-yes').addClass('btn-outline-success')
      $('#participate-no').removeClass('btn-danger')
      $('#participate-no').addClass('btn-outline-danger')

  @send_decision: (decision) ->
    $.ajax(
      url: $('#participation-buttons').data('update-url'),
      method: "PATCH",
      data: {invitation: {decision: decision}}
    ).done((d) -> InvitationsController.set_participation_buttons())


  @manage_participation: ->
    InvitationsController.set_participation_buttons()
    InvitationsController.toggle_participation_choice()

    $('.participation-btn').on('click', (e) ->
      elem_id = $(this).attr('id')
      val = $('#invitation_decision').val()
      # console.log "val:     #{val}"     # waiting/participate/do_not_participate
      # console.log "elem_id: #{elem_id}" # participate-yes/participate-no
      if val!="participate" && elem_id=="participate-yes"
        $('.who-participates').removeClass('d-none')
        $('#invitation_decision').val('participate')
        InvitationsController.send_decision("participate")

      else if elem_id=="participate-no"
        if val=="waiting"
          $('.who-participates').addClass('d-none')
          $('#invitation_decision').val('do_not_participate')
          InvitationsController.send_decision("do_not_participate")


        else if val=="participate"
          url = $('#participation-buttons').data('has-app-url')
          $.get(url).done((data) ->
            if data=='true'
              $('#confirm-non-participation-modal').modal('show')
            else
              $('.who-participates').addClass('d-none')
              $('#invitation_decision').val('do_not_participate')
              InvitationsController.send_decision("do_not_participate")
          )
      InvitationsController.set_participation_buttons()
    )

  @toggle_participation_choice: ->
    val = $('#invitation_decision').val()
    if val=='participate'
      $('.who-participates').removeClass('d-none')
    else
      $('.who-participates').addClass('d-none')


  @manage_participation_old: ->

    val = $('#invitation_decision').val()
    if val=='participate'
      # $('.who-participates').show()
      $('.who-participates').removeClass('d-none')
    else

      # $('.who-participates').hide()
      url = $('#participate-yes').data('url')
      console.log url
      $.get(url).done((data) ->
        if data=='true'
          $('#confirm-non-participation-modal').modal('show')
          console.log data
      )

      $('.who-participates').addClass('d-none')


this.App.invitations = new InvitationsController
