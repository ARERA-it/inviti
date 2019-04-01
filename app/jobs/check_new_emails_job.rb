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
      # email_body = (mail.html_part && mail.html_part.body.raw_source) || mail.body.to_s
      # email_body_preview = (mail.text_part && mail.text_part.body.to_s) || Nokogiri::HTML(email_body).text


      if inv.nil?
        inv = Invitation.new
        inv.email_from_name          = e.from.map(&:name).join('; ')
        inv.email_from_address       = e.from.map{|i| "#{i.mailbox}@#{i.host}"}.join('; ')
        inv.email_subject            = Mail::Encodings.value_decode(e.subject).gsub(/^Fwd: /, "").gsub(/^I: /, "").gsub(/^FWD: /, "")
        inv.email_received_date_time = datetime

        # keep the original attributes
        inv.email_decoded   = mail.html_part.decoded
        # inv.email_text_part = mail.text_part && mail.text_part.body.to_s
        # inv.email_html_part = mail.html_part && mail.html_part.decoded # mail.html_part.body.raw_source


        inv.email_body         = mail.html_part.decoded
        s = Nokogiri::HTML(mail.html_part.decoded).text
        s = s.gsub("\r\n", "\n").gsub(/[\n]+/, "\n").gsub(/<!--.+-->/m, "")
        inv.email_body_preview = s


        # inv.email_body = email_body.gsub("\r\n", "\n").gsub("\n\n", "\n").gsub(/<!-- (.)+(\n)?(.)+ -->/, "") if email_body
        # inv.email_body_preview = email_body_preview.gsub("\r\n", "\n").gsub("\n\n", "\n").gsub(/<!-- (.)+(\n)?(.)+ -->/, "") if email_body_preview

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
