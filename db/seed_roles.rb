Role.all.destroy_all

abstr = Role.find_or_create_by(name: "_main_", code: Role::ABSTRACT)

Permission.where(role_id: abstr.id).destroy_all

# ['', '', false],

arr = [
  ['invitation', 'index', true],
  ['invitation', 'show', true],
  ['invitation', 'express_opinion', false],
  ['invitation', 'view_opinion', false],
  ['invitation', 'view_appointee', false],
  ['invitation', 'view_contributions', false],
  ['invitation', 'see_all', true],
  ['invitation', 'only_see_his_own', true],

  ['page', 'follow_ups', false],

  ['role', 'index', false],
  ['role', 'show', false],
  ['role', 'create', false],
  ['role', 'update', false],
  ['role', 'duplicate', false],
  ['role', 'destroy', false],

  ['group', 'index', false],
  ['group', 'show', false],
  ['group', 'create', false],
  ['group', 'update', false],
  ['group', 'destroy', false],

  ['user', 'index', false],
  ['user', 'show', false],
  ['user', 'create', false],
  ['user', 'update', false],
  ['user', 'destroy', false],
  ['user', 'update_sensitive_attributes', false],

  ['user_interaction', 'index', false],

]
arr.each do |el|
  # abstr.permissions.create(controller: el[0], action: el[1], permitted: el[2])
  Permission.find_or_create_by(role_id: abstr.id, controller: el[0], action: el[1]) do |p|
    p.permitted = el[2]
  end
end

[
  ["Ospite", Role::GUEST],
  ["Superuser", Role::SUPERUSER],
  ["Amministratore", Role::ADMIN],
].each do |e|
  guest = Role.find_or_create_by(name: e[0], code: e[1])
  guest.sync_roles
end


u = User.find_by(username: "hanskruger@example.it")
if u
  u.role = Role.superuser
  u.save
end

guest_role = Role.guest
User.all.each do |u|
  if u.role.nil?
    u.role = guest_role
    u.save
  end
end
