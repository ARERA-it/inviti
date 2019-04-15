class UsersController
  init: ->

  new: ->
    $('#user_role').on('change', ->
      UsersController.manage_advisor_group()
    )
    UsersController.manage_advisor_group()

  edit: ->
    $('#user_role').on('change', ->
      UsersController.manage_advisor_group()
    )
    UsersController.manage_advisor_group()


  @manage_advisor_group: ->
    val = $('#user_role').val()
    console.log val
    if val!='advisor'
      $('#user_advisor_group').val('not_advisor')


this.App.users = new UsersController
