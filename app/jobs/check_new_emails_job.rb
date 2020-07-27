class CheckNewEmailsJob < ApplicationJob
  queue_as :default

  def perform
    # Rails.logger.info("-> CheckNewEmailsJob.perform here.")
    # Rake::Task['inviti:check_emails'].invoke

    Rails.logger.info "-----> Check for new emails -------"

    imap = InvitiIMAP.new
    while msg = imap.get_one_msg

      unless Invitation.find_by(email_id: Mail.new(msg[:body]).message_id)
        email = Email.new(msg)
        email.import
      end




      # e = msg[:envelope]
      # b = msg[:body]
      # Rails.logger.info "-----> found a new email! title: '#{e.subject}' -------"
      # mail = Mail.new(b)
      # ff = e.from.first
      # datetime = DateTime.parse(e.date)
      #
      # inv = Invitation.find_by(email_id: mail.message_id)
      #
      # if inv.nil?
      #   inv = Invitation.new
      #   efn = e.from.map(&:name).join('; ')
      #   efa = e.from.map{|i| "#{i.mailbox}@#{i.host}"}.join('; ')
      #
      #   puts "-----> #{efn}"
      #   puts "-----> #{efa}"
      #   inv.email_from_name          = efn
      #   inv.save
      #
      #
      #   inv.update_attribute(:email_from_address, efa)
      #
      #   inv.update_attribute(:email_subject, Mail::Encodings.value_decode(e.subject).gsub(/^Fwd: /, "").gsub(/^I: /, "").gsub(/^FWD: /, ""))
      #   inv.email_received_date_time(:email_received_date_time, datetime)
      #
      #   # inv.email_subject            = Mail::Encodings.value_decode(e.subject).gsub(/^Fwd: /, "").gsub(/^I: /, "").gsub(/^FWD: /, "")
      #   # inv.email_received_date_time = datetime
      #   #
      #   # inv.save
      #
      #   email_body = mail.html_part.try(:decoded) || mail.body.to_s
      #   unless email_body.valid_encoding?
      #     email_body.scrub!("")
      #   end
      #   # decoded    = email_body
      #
      #   # inv.email_body         = email_body
      #   inv.update_attribute(:email_body, email_body)
      #
      #   # email_decoded will be set by Invitation before_create callback
      #
      #   s = Nokogiri::HTML(email_body).text
      #   s = s.gsub("\r\n", "\n").gsub(/[\n]+/, "\n").gsub(/<!--.+-->/m, "")
      #   inv.email_body_preview = s
      #   inv.update_attribute(:email_body_preview, s)
      #
      #   # inv.save
      #
      #   mail.attachments.each do |att|
      #     temp_file = Tempfile.new('attachment')
      #     begin
      #       File.open(temp_file.path, 'wb') do |file|
      #         file.write(att.body.decoded)
      #       end
      #       inv.files.attach(io: File.open(temp_file.path), filename: att.filename)
      #     ensure
      #        temp_file.close
      #        temp_file.unlink   # deletes the temp file
      #     end
      #   end
      # end
    end

  end





end
