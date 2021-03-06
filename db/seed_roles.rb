arr = [
  ['invitation', 'index', true],
  ['invitation', 'show', true],
  ['invitation', 'audits', true],
  # ['invitation', 'express_opinion', false],
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

  ['project', 'update', false],

  ['request_opinion', 'create', false], # può richiedere opinione?
  ['request_opinion', 'show', false], # può vedere le richieste di opinioni?
  ['opinion', 'show', false],
  ['opinion', 'express', false], # in alternativa quello incluso nel gruppo con 'ask_opinion'=true
  ['comment', 'show', false],
  ['comment', 'create', false],
  ['appointee', 'create', false],
  ['appointee', 'change', false]

]


Role.all.destroy_all # will destroy permissions too
[
  ["Ospite", Role::GUEST],
  ["Superuser", Role::SUPERUSER],
  ["Amministratore", Role::ADMIN],
].each do |e|
  role = Role.find_or_create_by(name: e[0], code: e[1])
  arr.each do |el|
    Permission.find_or_create_by(role_id: role.id, controller: el[0], action: el[1]) do |p|
      p.permitted = el[2]
    end
  end
end


if u = User.find_by(username: "hanskruger@example.it")
  u.role = Role.superuser
  u.save
end

guest_role = Role.guest
User.all.each do |u|
  u.update_attribute(:role, guest_role) if u.role.nil?
end

Permission.where(role: Role.admin).update_all(permitted: true)
Permission.where(role: Role.superuser).update_all(permitted: true)

# Permission.find_or_create_by(role: Role.superuser, controller: 'project', action: 'update', permitted: true)
