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

      if inv.nil?
        inv = Invitation.new
        inv.email_from_name          = e.from.map(&:name).join('; ')
        inv.email_from_address       = e.from.map{|i| "#{i.mailbox}@#{i.host}"}.join('; ')
        inv.email_subject            = Mail::Encodings.value_decode(e.subject).gsub(/^Fwd: /, "").gsub(/^I: /, "").gsub(/^FWD: /, "")
        inv.email_received_date_time = datetime


        email_body = mail.html_part.try(:decoded) || mail.body.to_s
        unless email_body.valid_encoding?
          email_body.scrub!("")
        end
        # decoded    = email_body

        inv.email_body         = email_body
        # email_decoded will be set by Invitation before_create callback

        s = Nokogiri::HTML(email_body).text
        s = s.gsub("\r\n", "\n").gsub(/[\n]+/, "\n").gsub(/<!--.+-->/m, "")
        inv.email_body_preview = s

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
