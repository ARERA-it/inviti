class InvitiIMAP
  READ_MSG_FOLDER = "LETTE"

  def initialize
    @imap = Net::IMAP.new(ENV["IMAP_HOST"], port: 993, ssl: true)
    @imap.login(ENV["IMAP_USER"], ENV["IMAP_PWD"])
    check_read_msg_folder
  end

  def check_read_msg_folder
    begin
      @imap.examine(READ_MSG_FOLDER)
    rescue
      @imap.create(READ_MSG_FOLDER)
    end
  end

  def get_one_msg
    @imap.examine('INBOX') # read only
    if seqno = @imap.search(["RECENT"]).shift
      msg = {}
      msg[:envelope] = @imap.fetch(seqno, "ENVELOPE")[0].attr["ENVELOPE"]
      msg[:body]     = @imap.fetch(seqno, "RFC822")[0].attr['RFC822']
      @imap.move(seqno, "LETTE")
      return msg
    end
    nil
  end


  # return an object like this:
  # => #<struct Net::IMAP::FetchData seqno=1, attr={"ENVELOPE"=>#<struct Net::IMAP::Envelope
  #    date="Thu, 14 Mar 2019 17:27:12 +0100", subject="email7",
  #    from=[#<struct Net::IMAP::Address name="Buetti Iwan",
  #    route=nil, mailbox="ibuetti", host="arera.it">], sender=nil, reply_to=nil,
  #    to=[#<struct Net::IMAP::Address name="Invititest", route=nil, mailbox="INVITITEST", host="arera.it">],
  #    cc=nil, bcc=nil, in_reply_to=nil, message_id="<4f4a3d8bccde491585825281b171cade@arera.it>">}>
end
