require 'rubygems'
require 'excon'

require 'net/http' # for Gzip and Zlib



 class LazyStringIO
      def initialize(string="")
        @stream = string
      end

      def <<(string)
        @stream << string
      end

      def read(length=nil, buffer=nil)
        buffer ||= ""
        length ||= 0
        buffer << @stream[0..(length-1)]
        @stream = @stream[length..-1]
        buffer
      end

      def size
        @stream.size
      end
    end

streamer = lambda do |chunk, remaining_bytes, total_bytes|
  #puts chunk
  puts "doing a chunk"
  #puts chunk
    #puts "Remaining: #{remaining_bytes.to_f / total_bytes}%"
  	#buf = LazyStringIO.new(chunk)
	@buf ||= LazyStringIO.new
    @buf << chunk  	
  	#buf << chunk
	#sio = StringIO.new( chunk )
	
	# Zlib::GzipReader loads input in 2048 byte chunks
	if @buf.size > 2048
		puts "doing a read"
		puts @buf.read
    	@gzip ||= Zlib::GzipReader.new( @buf )
    	#body = 
    	@gzip.readline
    	#puts body
    end   
end

connection = Excon.new('http://geemus.com') #:proxy => 'http://127.0.0.1:8888',
c = connection.request(:method => 'GET', :headers => {'Accept-Encoding' => 'gzip, deflate'}, :response_block => streamer)

#finalise
@gzip ||= Zlib::GzipReader.new @buf
puts  @gzip.read

#puts c.headers
#if c.headers['Content-Encoding'] == 'gzip' && false
#	sio = StringIO.new( c.body )
#    gz = Zlib::GzipReader.new( sio )
#    body = gz.read() 
#end

#puts body
