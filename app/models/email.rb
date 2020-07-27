class Email

  def initialize(msg)
    @envelope = msg[:envelope]
    @body = msg[:body]
    Rails.logger.info "-----> found a new email! title: '#{@envelope.subject}' -------"
  end

  def import
    mail     = Mail.new(@body)
    from     = @envelope.from.first
    datetime = DateTime.parse(@envelope.date)

    inv = Invitation.new
    efn = @envelope.from.map(&:name).join('; ')
    efa = @envelope.from.map{|i| "#{i.mailbox}@#{i.host}"}.join('; ')

    puts "-----> #{efn}"
    puts "-----> #{efa}"
    inv.email_from_name          = efn
    inv.save


    inv.update_attribute(:email_from_address, efa)

    inv.update_attribute(:email_subject, Mail::Encodings.value_decode(e.subject).gsub(/^Fwd: /, "").gsub(/^I: /, "").gsub(/^FWD: /, ""))
    inv.email_received_date_time(:email_received_date_time, datetime)

    email_body = mail.html_part.try(:decoded) || mail.body.to_s
    unless email_body.valid_encoding?
      email_body.scrub!("")
    end
    inv.update_attribute(:email_body, email_body)


    s = Nokogiri::HTML(email_body).text
    s = s.gsub("\r\n", "\n").gsub(/[\n]+/, "\n").gsub(/<!--.+-->/m, "")
    # inv.email_body_preview = s
    inv.update_attribute(:email_body_preview, s)



    email_decoded = convert_dash_dash(email_body)
    inv.update_attribute(:email_decoded, email_decoded)

    # inv.save

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

  private

  def start_with_dash_dash?(txt)
    txt[0..1]=="--"
  end

  def convert_dash_dash(txt)
    return txt if !start_with_dash_dash?(txt)
    dd_block = detect_dd_block(txt)
    pieces = txt.split(dd_block)
    puts "found #{pieces.size} pieces"
    result = []
    pieces.each do |p|
      if get_content_type(p)=="text/plain"
        charset = get_charset(p)
        cte = get_cte(p)
        # puts get_content_type(p) # "text/plain"
        # puts get_charset(p)      # "utf-8"
        # puts get_cte(p)          # "base64"

        encoded_part = p.split("Content-Transfer-Encoding: #{cte}").last
        case cte
        when "base64"
          decoded = Base64.decode64(encoded_part)
          decoded = decoded.force_encoding(charset)
          result << decoded
        when "quoted-printable", "quoted"
          result << encoded_part.gsub("= ", "").unpack('M').first.force_encoding(charset).encode('utf-8')
        end
      end
    end
    return txt if result.empty?
    result.join("\n\n")
  end



  def get_content_type(txt)
    match_data = txt.match(/Content-Type: ([\w\/]+);/)
    match_data && match_data[1]
  end

  def get_charset(txt)
    match_data = txt.match(/charset="([\w-]+)"/)
    match_data && match_data[1]
  end

  def get_cte(txt)
    match_data = txt.match(/Content-Transfer-Encoding: ([\w]+)/)
    match_data && match_data[1]
  end

  # charset="utf-8"


  def detect_dd_block(txt)
    match_data = txt.match(/--\w+/)
    match_data && match_data[0]
  end

end
