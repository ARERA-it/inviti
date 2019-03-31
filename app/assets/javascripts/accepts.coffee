class AcceptsController
  edit: ->
    AcceptsController.manage_behaviour()

    $('#accept_decision').on 'change', ->
      AcceptsController.manage_behaviour()

  @manage_behaviour: ->
    v = $('#accept_decision').val() # "", or "accepted" or "rejected"
    $('#submit-btn').attr('disabled', v=="")
    if v=="rejected"
      $('#accept_comment').removeClass('d-none')
    else
      $('#accept_comment').addClass('d-none')

this.App.accepts = new AcceptsController
