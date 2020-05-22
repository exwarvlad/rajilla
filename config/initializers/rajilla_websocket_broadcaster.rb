require 'curb'

module RajillaWebsocketBroadcaster
  def broadcast(message)
    begin
      c = Curl::Easy.http_post("http://localhost:8081", message) do |curl|
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.headers['Api-Version'] = '2.2'
      end
      c.perform
    rescue Curl::Err::GotNothingError
      '200 0K'
    end
  end
end
