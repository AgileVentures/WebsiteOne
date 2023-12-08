require 'test/unit'
require 'evma_httpserver'

begin
  once = false
  require 'eventmachine'
rescue LoadError => e
  raise e if once
  once = true
  require 'rubygems'
  retry
end



#--------------------------------------

module EventMachine
  module HttpServer
    def process_http_request
      send_data generate_response()
      close_connection_after_writing
    end
  end
end

#--------------------------------------

require 'socket'

class TestApp < Test::Unit::TestCase

  TestHost = "127.0.0.1"
  TestPort = 8911

  TestResponse_1 = <<EORESP
HTTP/1.0 200 ...
Content-length: 4
Content-type: text/plain
Connection: close

1234
EORESP

  Thread.abort_on_exception = true

  def test_simple_get
    received_response = nil

    EventMachine::HttpServer.module_eval do
      def generate_response
        TestResponse_1
      end
    end


    EventMachine.run do
      EventMachine.start_server TestHost, TestPort, EventMachine::HttpServer
      EventMachine.add_timer(1) {raise "timed out"} # make sure the test completes

      cb = proc do
        tcp = TCPSocket.new TestHost, TestPort
        tcp.write "GET / HTTP/1.0\r\n\r\n"
        received_response = tcp.read
      end
      eb = proc { EventMachine.stop }
      EventMachine.defer cb, eb
    end

    assert_equal( TestResponse_1, received_response )
  end




  # This frowsy-looking protocol handler allows the test harness to make some
  # its local variables visible, so we can set them here and they can be asserted later.
  class MyTestServer < EventMachine::Connection
    include EventMachine::HttpServer
    def initialize *args
      super
    end
    def generate_response
      @assertions.call
      TestResponse_1
    end
  end



  def test_parameters
    path_info = "/test.html"
    query_string = "a=b&c=d"
    cookie = "eat_me=I'm a cookie"
    etag = "12345"

    # collect all the stuff we want to assert outside the actual test,
    # to ensure it gets asserted even if the test catches some exception.
    received_response = nil
    request_parms = {}


    EventMachine.run do
      EventMachine.start_server(TestHost, TestPort, MyTestServer) do |conn|
        # In each accepted connection, set up a procedure that will copy
        # the request parameters into a local variable visible here, so
        # we can assert the values later.
        conn.instance_eval do
          @assertions = proc {
            parms = %w( PATH_INFO QUERY_STRING HTTP_COOKIE IF_NONE_MATCH
            CONTENT_TYPE REQUEST_METHOD REQUEST_URI )
            parms.each {|parm|
              # request_parms is bound to a local variable visible in this context.
              request_parms[parm] = ENV[parm]
            }
          }
        end
      end
      EventMachine.add_timer(1) {raise "timed out"} # make sure the test completes

      cb = proc do
        tcp = TCPSocket.new TestHost, TestPort
        data = [
          "GET #{path_info}?#{query_string} HTTP/1.1\r\n",
          "Cookie: #{cookie}\r\n",
          "If-none-match: #{etag}\r\n",
          "\r\n"
        ].join
        tcp.write(data)
        received_response = tcp.read
      end
      eb = proc { EventMachine.stop }
      EventMachine.defer cb, eb
    end

    assert_equal( TestResponse_1, received_response )
    assert_equal( path_info, request_parms["PATH_INFO"] )
    assert_equal( query_string, request_parms["QUERY_STRING"] )
    assert_equal( cookie, request_parms["HTTP_COOKIE"] )
    assert_equal( etag, request_parms["IF_NONE_MATCH"] )
    assert_equal( nil, request_parms["CONTENT_TYPE"] )
    assert_equal( "GET", request_parms["REQUEST_METHOD"] )
    assert_equal( path_info, request_parms["REQUEST_URI"] )
  end


  def test_headers
    received_header_string = nil
    received_header_ary = nil

    EventMachine.run do
      EventMachine.start_server(TestHost, TestPort, MyTestServer) do |conn|
        # In each accepted connection, set up a procedure that will copy
        # the request parameters into a local variable visible here, so
        # we can assert the values later.
        # The @http_headers is set automatically and can easily be parsed.
        # It isn't automatically parsed into Ruby values because that is
        # a costly operation, but we should provide an optional method that
        # does the parsing so it doesn't need to be done by users.
        conn.instance_eval do
          @assertions = proc do
            received_header_string = @http_headers
            received_header_ary = @http_headers.split(/\0/).map {|line| line.split(/:\s*/, 2) }
          end
        end
      end

      cb = proc do
        tcp = TCPSocket.new TestHost, TestPort
        data = [
          "GET / HTTP/1.1\r\n",
          "aaa: 111\r\n",
          "bbb: 222\r\n",
          "ccc: 333\r\n",
          "ddd: 444\r\n",
          "\r\n"
        ].join
        tcp.write data
        received_response = tcp.read
      end
      eb = proc { EventMachine.stop }
      EventMachine.defer cb, eb

      EventMachine.add_timer(1) {raise "timed out"} # make sure the test completes
    end

    assert_equal( "aaa: 111\0bbb: 222\0ccc: 333\0ddd: 444\0\0", received_header_string )
    assert_equal( [["aaa","111"], ["bbb","222"], ["ccc","333"], ["ddd","444"]], received_header_ary )
  end





  def test_post
    received_header_string = nil
    post_content = "1234567890"
    content_type = "text/plain"
    received_post_content = ""
    received_content_type = ""

    EventMachine.run do
      EventMachine.start_server(TestHost, TestPort, MyTestServer) do |conn|
        # In each accepted connection, set up a procedure that will copy
        # the request parameters into a local variable visible here, so
        # we can assert the values later.
        # The @http_post_content variable is set automatically.
        conn.instance_eval do
          @assertions = proc do
            received_post_content = @http_post_content
            received_content_type = ENV["CONTENT_TYPE"]
          end
        end
      end
      EventMachine.add_timer(1) {raise "timed out"} # make sure the test completes

      cb = proc do
        tcp = TCPSocket.new TestHost, TestPort
        data = [
          "POST / HTTP/1.1\r\n",
          "Content-type: #{content_type}\r\n",
          "Content-length: #{post_content.length}\r\n",
          "\r\n",
          post_content
        ].join
        tcp.write(data)
        received_response = tcp.read
      end
      eb = proc do
        EventMachine.stop
      end
      EventMachine.defer cb, eb
    end

    assert_equal( received_post_content, post_content )
    assert_equal( received_content_type, content_type )
  end

end