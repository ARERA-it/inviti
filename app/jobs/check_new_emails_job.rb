class CheckNewEmailsJob < ApplicationJob
  queue_as :default

  def perform
    # Rails.logger.info("-> CheckNewEmailsJob.perform here.")
    # Rake::Task['inviti:check_emails'].invoke

    Rails.logger.info "-----> Check for new emails -------"

    imap = InvitiIMAP.new
    while msg = imap.get_one_msg
      e = msg[:envelope]
      b = msg[:body]
      Rails.logger.info "-----> found a new email! title: '#{e.subject}' -------"
      mail = Mail.new(b)
      ff = e.from.first
      datetime = DateTime.parse(e.date)

      inv = Invitation.find_by(email_id: mail.message_id)
      email_body = mail.html_part && mail.html_part.body.raw_source
      email_body_preview = (mail.text_part && mail.text_part.body.to_s) || Nokogiri::HTML(email_body).text


      if inv.nil?
        inv = Invitation.new
        inv.email_from_name = ff.name
        inv.email_from_address = "#{ff.mailbox}@#{ff.host}"
        inv.email_subject = e.subject
        inv.email_body = email_body.gsub("\r\n", "\n").gsub("\n\n", "\n").gsub(/<!-- (.)+(\n)?(.)+ -->/, "") if email_body
        inv.email_body_preview = email_body_preview.gsub("\r\n", "\n").gsub("\n\n", "\n").gsub(/<!-- (.)+(\n)?(.)+ -->/, "") if email_body_preview
        inv.email_received_date_time = datetime
        inv.save

        mail.attachments.each do |att|
          temp_file = Tempfile.new('attachment')
          begin
            File.open(temp_file.path, 'wb') do |file|
              file.write(att.body.decoded)
            end
            inv.files.attach(io: File.open(temp_file.path), filename: att.filename)
          ensure
             temp_file.close
             temp_file.unlink   # deletes the temp file
          end
        end
      end
    end

  end
end
