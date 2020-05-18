require 'faye/websocket'
require 'eventmachine'

module RajillaWebsocketBroadcaster
  def broadcast(message)
    EM.run {
      ws = Faye::WebSocket::Client.new(ENV['WS_URL'])

      ws.on :open do |event|
        ws.send(message)
      end

      ws.on :message do |event|
        p [:message, event.data]
        EM.stop
      end
    }
  end
end
