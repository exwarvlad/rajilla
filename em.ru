# frozen_string_literal: true

require 'eventmachine'
require 'webrick'
require 'faye/websocket'

module EchoServer
  def receive_data(data)
    req = WEBrick::HTTPRequest.new(WEBrick::Config::HTTP)
    req.parse(StringIO.new(data))

    $ws.send(req.body)
    close_connection
  end
end

EventMachine.run do
  $ws = Faye::WebSocket::Client.new('ws://localhost:3000')

  $ws.on :open do
    $ws.send('Hello, WS!')
  end

  $ws.on :message do |event|
    p [:message, event.data]
  end
  EventMachine.start_server '127.0.0.1', 8081, EchoServer
end
