#!/usr/bin/env ruby
require 'eventmachine'
require 'websocket/driver'
require 'byebug'

module Connection
  def initialize
    @driver = WebSocket::Driver.server(self)

    @driver.on :connect, proc { |event|
      puts "someone is Connected"
      if WebSocket::Driver.websocket?(@driver.env)
        puts "websocket req"
        @driver.start
      else
        # handle other HTTP requests
      end
    }

    @driver.on :message, proc { |e|
    }
    @driver.on :close, proc {|e|
      puts "connection closed"
      close_connection_after_writing
    }
  end

  def receive_data(data)
    @driver.parse(data)
  end

  def write(data)
    byebug
    send_data(data)
  end
end

EM.run {
  EM.start_server('127.0.0.1', 4180, Connection)
}

