class GroupsController
  init: ->
  new: ->
    $('#group_user_ids').select2()

  edit: ->
    $('#group_user_ids').select2()

  show: ->
    $('#group_user_ids').select2(disabled: true)


this.App.groups = new GroupsController
