require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config(File.join(Rails.root, 'config', "google-api-credentials.json"))

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
ws = session.spreadsheet_by_key("1iDIaUccPg60ME7Pp7of4OMZLWygd1kP1Tm2p6S9ZQZA").worksheets[0]

# Gets content of A2 cell.
# p ws[2, 1]  #==> "hoge"


# Dumps all cells.
# (1..ws.num_rows).each do |row|
#   (1..ws.num_cols).each do |col|
#     p ws[row, col]
#   end
# end


# (1..ws.num_cols).each do |col|
#   p ws[row, col]
# end


# https://github.com/gimite/google-drive-ruby

# https://docs.google.com/spreadsheets/d/1iDIaUccPg60ME7Pp7of4OMZLWygd1kP1Tm2p6S9ZQZA/edit#gid=0

# Attenzione:
# creo i ruoli fondamentali (se non esistono già)
# Role.destroy_all; Permission.destroy_all

[
  ["Superuser", "superuser"],
  ["Amministratore", "admin"],
  ["Ospite", "guest"]
].each do |a|
  Role.find_or_create_by(code: a[1]) do |role|
    role.name = a[0]
  end
end

# Roles
roles_offset = 5
head_row    = ws.rows[0] #   ["Domain", "Description", "Controller", "Action", "Note", "Superuser", "Admin", "Guest", "Presidente", "Commissario", "Consigliere", "Segreterie"]
roles =  head_row[roles_offset..-1].map.with_index do |e, i|
  r = Role.find_or_create_by(name: e.strip)
  [i+roles_offset, r]
end.to_h  #  { col_num => role }

# roles_names =  head_row[roles_offset..-1].map.with_index{|e, i| [i+roles_offset, e]}.to_h # {5=>"Superuser", 6=>"Admin", 7=>"Guest", 8=>"Presidente", 9=>"Commissario", 10=>"Consigliere", 11=>"Segreterie"}

permissions = ws.rows[1..-1].map.with_index do |row, i|
  # puts "i: #{i}"
  perm = Permission.find_or_create_by(controller: row[2], action: row[3]) do |p|
    p.domain      = row[0]
    p.description = row[1]
  end
  [i+1, perm]
end.to_h  #  { row_num => permission }


# Permissions and RolePermission
permissions.each_pair do |row_num, perm|
  roles.each_pair do |col_num, role|
    # puts "#{row_num}/#{col_num}"
    pr = PermissionRole.find_or_create_by(role: role, permission: perm)
    pr.update_column(:permitted, ws.rows[row_num][col_num]=='TRUE')
  end
end

if Rails.env=="development"
  # User.all.map{|e| [e.id, e.role.code]}
  [[1, "presidente"], [7, "superuser"], [3, "guest"], [5, "segreterie"], [2, "commissario"], [6, "consigliere"], [4, "admin"]].each do |user_id, role_code|
    User.find(user_id).update_attribute(:role, Role.find_by(code: role_code))
  end
end
