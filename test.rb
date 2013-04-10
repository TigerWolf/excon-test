require 'rubygems'
require 'excon'

require 'net/http' # for Gzip and Zlib

streamer = lambda do |chunk, remaining_bytes, total_bytes|
  puts chunk
  puts "Remaining: #{remaining_bytes.to_f / total_bytes}%"
end

connection = Excon.new('http://geemus.com', :response_block => streamer) #:proxy => 'http://127.0.0.1:8888',
c = connection.request(:method => 'GET', :headers => {'Accept-Encoding' => 'gzip, deflate'})
puts c.headers
if c.headers['Content-Encoding'] == 'gzip'
	sio = StringIO.new( c.body )
    gz = Zlib::GzipReader.new( sio )
    body = gz.read() 
end

puts body
