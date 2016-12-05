#!/usr/bin/env ruby
require 'eventmachine'
require 'websocket/driver'
require 'socket'
require 'byebug'

class WS
  attr_reader :url
  attr_reader :driver
  attr_reader :io
  def initialize(host, port)
    @url = "ws://#{host}:#{port}"
    @io = TCPSocket.new(host, port)
    @driver = WebSocket::Driver.client(self)
    @driver.on :message, proc { |e|
      puts "data: #{e.data}"
    }
    @driver.on :open, proc {|e| puts "Server opened"}
    @driver.start
  end

  def write(string)
    @io.write(string)
  end
end

#ws = WS.new("127.0.0.1", 4180)
ws = WS.new("echo.websocket.org", 80)
p ws.driver.text("AABB!")
puts "state: #{ws.driver.status}"
m = ws.io.gets
byebug
p ws.driver.parse(m)
