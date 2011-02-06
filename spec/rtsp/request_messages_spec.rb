require File.dirname(__FILE__) + '/../spec_helper'
require 'rtsp/request_messages'
require 'sdp'

describe RTSP::RequestMessages do
  include RTSP::RequestMessages

  before do
    @stream = "rtsp://1.2.3.4/stream1"
    @options = {}
  end

  context "should build an OPTIONS message" do
    it "with default sequence number" do
      message = RTSP::RequestMessages.options @stream
      message.should == "OPTIONS rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 1\r\n\r\n"
    end

    it "with passed-in sequence number" do
      message = RTSP::RequestMessages.options(@stream, 2345)
      message.should == "OPTIONS rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 2345\r\n\r\n"
    end
  end

  context "should build a DESCRIBE message" do
    it "with default sequence and accept values" do
      message = RTSP::RequestMessages.describe @stream
      message.should == "DESCRIBE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 1\r\n\Accept: application/sdp\r\n\r\n"
    end

    it "with default sequence value" do
      @options[:accept] = ['application/sdp', 'application/rtsl']
      message = RTSP::RequestMessages.describe(@stream, @options)
      message.should == "DESCRIBE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 1\r\n\Accept: application/sdp, application/rtsl\r\n\r\n"
    end

    it "with passed-in sequence and accept values" do
      @options[:accept] = ['application/sdp', 'application/rtsl']
      @options[:sequence] = 2345
      message = RTSP::RequestMessages.describe(@stream, @options)
      message.should == "DESCRIBE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 2345\r\n\Accept: application/sdp, application/rtsl\r\n\r\n"
    end
  end

  context "should build a ANNOUNCE message" do
    it "with default sequence, content type, sdp, and content length values" do
      message = RTSP::RequestMessages.announce(@stream, 123456789)
      message.should == "ANNOUNCE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 1\r\n\Date: \r\nSession: 123456789\r\nContent-Type: application/sdp\r\nContent-Length: 25\r\n\r\nv=0\r\no=     \r\ns=\r\nt= \r\n\r\n"
    end

    it "with default sequence value" do
      @options[:content_type] = 'application/sdp'
      message = RTSP::RequestMessages.announce(@stream, 123456789, @options)
      message.should == "ANNOUNCE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 1\r\n\Date: \r\nSession: 123456789\r\nContent-Type: application/sdp\r\nContent-Length: 25\r\n\r\nv=0\r\no=     \r\ns=\r\nt= \r\n\r\n"
    end

    it "with passed-in sequence, content-type values" do
      @options[:content_type] = 'application/sdp'
      @options[:sequence] = 2345
      message = RTSP::RequestMessages.announce(@stream, 123456789, @options)
      message.should == "ANNOUNCE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 2345\r\n\Date: \r\nSession: 123456789\r\nContent-Type: application/sdp\r\nContent-Length: 25\r\n\r\nv=0\r\no=     \r\ns=\r\nt= \r\n\r\n"
    end

    it "with passed-in sequence, content-type, sdp values" do
      @options[:content_type] = 'application/sdp'
      @options[:sequence] = 2345
      @options[:sdp] = SDP::Description.new
      @options[:sdp].protocol_version = 1
      @options[:sdp].username = 'bobo'
      message = RTSP::RequestMessages.announce(@stream, 123456789, @options)
      message.should == "ANNOUNCE rtsp://1.2.3.4/stream1 RTSP/1.0\r\nCSeq: 2345\r\n\Date: \r\nSession: 123456789\r\nContent-Type: application/sdp\r\nContent-Length: 29\r\n\r\nv=1\r\no=bobo     \r\ns=\r\nt= \r\n\r\n"
    end
  end
end