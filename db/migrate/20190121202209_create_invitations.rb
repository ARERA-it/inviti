class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.string   :title
      t.string   :location
      t.datetime :from_date_and_time, index: true
      t.datetime :to_date_and_time
      t.string   :organizer
      t.text     :notes

      t.string   :email_id
      t.string   :email_from_name
      t.string   :email_from_address
      t.string   :email_subject
      t.string   :email_body_preview
      t.text     :email_body
      t.datetime :email_received_date_time, index: true
      t.boolean  :has_attachments
      t.string   :attachments
      t.integer  :appointee_id, index: true
      t.string   :alt_appointee_name
      t.text     :delegation_notes


      t.timestamps
    end
  end
end
