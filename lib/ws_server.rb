require  'em-websocket'
require  'evma_httpserver'

class MyHttpServer < EventMachine::Connection
  include EventMachine::HttpServer
  def process_http_request
    # the http request details are available via the following instance variables:
    # @http_protocol
    # @http_request_method
    # @http_cookie
    # @http_if_none_match
    # @http_content_type
    # @http_path_info
    # @http_request_uri
    # @http_query_string
    # @http_post_content
    # @http_headers
    puts @http_post_content
    response = EventMachine::DelegatedHttpResponse.new(self)
    response.status = 200
    response.content_type  'text/html'
    response.content =  ''
    response.send_response
    @websocket_connections.each do |socket|
      socket.send(@http_post_content)
    end
  end 
end


EventMachine.run do
  websocket_connections = []
  EventMachine::WebSocket.start(host: "192.41.170.118", port: 8080) do |ws|

    ws.onopen do
      puts "Websocket connection opened"
      websocket_connections << ws
      puts websocket_connections
    end

    ws.onclose do
      puts "Websocket connection closed"
      websocket_connections.delete(ws)
    end

  end 

  EventMachine.start_server( '192.41.170.118' , 3001, MyHttpServer) do |conn|
    conn.instance_variable_set(:@websocket_connections , websocket_connections)
  end

end
