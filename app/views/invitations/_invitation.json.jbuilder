json.extract! invitation, :id, :title, :location, :datetime, :organizer, :email_subject, :email_body, :email_received_date_time, :attachments, :email_id, :created_at, :updated_at
json.url invitation_url(invitation, format: :json)
