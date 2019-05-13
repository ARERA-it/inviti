require 'base64'

module EmailDecoder
  extend ActiveSupport::Concern

  included do
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
          when "quoted-printable"
            result << encoded_part.gsub("= ", "").unpack('M').first.force_encoding(charset).encode('utf-8')
          end

        end
      end
      return txt if result.empty?
      result.join("\n\n")
    end


    private

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


end
