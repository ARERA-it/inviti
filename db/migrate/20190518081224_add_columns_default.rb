class AddColumnsDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :accepts, :comment, from: nil, to: ""
    change_column_default :comments, :content, from: nil, to: ""
    change_column_default :contributions, :title, from: nil, to: ""
    change_column_default :contributions, :note, from: nil, to: ""
    change_column_default :invitations, :title, from: nil, to: ""
    change_column_default :invitations, :location, from: nil, to: ""
    change_column_default :invitations, :organizer, from: nil, to: ""
    change_column_default :invitations, :notes, from: nil, to: ""
    change_column_default :invitations, :delegation_notes, from: nil, to: ""
    change_column_default :invitations, :appointee_message, from: nil, to: ""
    change_column_default :invitations, :appointee_message, from: nil, to: ""
  end
end
