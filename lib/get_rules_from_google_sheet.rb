require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config(Path.join(Rails.root, 'config', 'google-api-credetials.json'))

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
ws = session.spreadsheet_by_key("1iDIaUccPg60ME7Pp7of4OMZLWygd1kP1Tm2p6S9ZQZA").worksheets[0]

# Gets content of A2 cell.
p ws[2, 1]  #==> "hoge"


# Dumps all cells.
(1..ws.num_rows).each do |row|
  (1..ws.num_cols).each do |col|
    p ws[row, col]
  end
end


(1..ws.num_cols).each do |col|
  p ws[row, col]
end


# https://github.com/gimite/google-drive-ruby

# https://docs.google.com/spreadsheets/d/1iDIaUccPg60ME7Pp7of4OMZLWygd1kP1Tm2p6S9ZQZA/edit#gid=0
