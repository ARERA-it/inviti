require 'faraday'
require 'json'

class DeviceFlow
  attr_reader :access_token, :refresh_token

  def initialize(tenant_id, client_id, scope: "https://outlook.office.com/IMAP.AccessAsUser.All offline_access")
    @tenant_id = tenant_id
    @client_id = client_id
    @url      = "https://login.microsoftonline.com"
    @scope     = scope
  end


  def device_code
    payload = { 
      client_id: @client_id, 
      scope: @scope
    }
    response = connect_and_post('devicecode', payload)
    hash = JSON.parse(response.body)

    if response.status==200
      # hash = {
      #   "user_code"=>"CNQ4SYJJ2",
      #   "device_code"=>
      #   "CAQABAAEAAAD--DLA3V...",
      #   "verification_uri"=>"https://microsoft.com/devicelogin",
      #   "expires_in"=>900,
      #   "interval"=>5,
      #   "message"=>"To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code CNQ4SYJJ2 to authenticate."
      # }
      # @user_code = hash['user_code']
      @device_code = hash['device_code']
      @verification_uri = hash['verification_uri']
      # @expires_in = hash['user_code']
      # @expires_at = Time.now + @expires_in
      # @message = hash['user_code']
      hash.slice('verification_uri', 'user_code')
    else
      hash.slice('error', 'error_description')
    end
  end


  def tokens(device_code: nil)
    @device_code = device_code if device_code
    raise "Device Code is empty" unless @device_code

    path    = "/#{@tenant_id}/oauth2/v2.0/token"
    payload = { 
      client_id: @client_id, 
      grant_type: "urn:ietf:params:oauth:grant-type:device_code", 
      device_code: @device_code
    }
    response = connect_and_post('token', payload)

    hash = JSON.parse(response.body)

    if response.status==200
      @access_token = hash['access_token']
      @refresh_token = hash['refresh_token']
      hash.slice('access_token', 'refresh_token')
    else
      hash.slice('error', 'error_description')
    end
  end



  def refresh_tokens(refresh_token: nil)
    payload = { 
      client_id: @client_id, 
      scope: @scope,
      refresh_token: refresh_token || @refresh_token,
      grant_type: 'refresh_token'
    }
    response = connect_and_post('token', payload)

    hash = JSON.parse(response.body)

    if response.status==200
      @access_token = hash['access_token']
      @refresh_token = hash['refresh_token']
      hash.slice('access_token', 'refresh_token')
    else
      hash.slice('error', 'error_description')
    end
  end


  private

  def path(endpoint)
    "/#{@tenant_id}/oauth2/v2.0/#{endpoint}"
  end

  def connect_and_post(endpoint, payload)
    conn = Faraday.new(
      url: @url,
      headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    )
    response = conn.post(path(endpoint)) do |req|
      req.body = payload
    end
  end

  def inspect_response(response)
    puts response.status.inspect
    # => 200

    puts response.headers.inspect
    # => {"server"=>"Fly/c375678 (2021-04-23)", "content-type"=> ...

    puts response.body.inspect
    # => "<!DOCTYPE html><html> ...
  end

  # TODO: exceptions?

end


# load './step_1b.rb'
if false
load './step_1b.rb'
tenant_id = "02463089-7fdf-4bbb-bc64-e2514b0455b1"
client_id = "bfd00cc0-b245-49dc-9f68-2d0ee1672028"

df = DeviceFlow.new(tenant_id, client_id)
dc = df.device_code
# ...
df.tokens

df.refresh_tokens

rt = "so fake"
rt = df.refresh_token
d = DeviceFlow.new(tenant_id, client_id)
d.refresh_tokens(refresh_token: rt)

end

