require 'pathname'

# This base module simply defines properties about the library.  See child
# classes/modules for the meat.
module RTSP
  WWW = 'http://github.com/turboladen/rtsp'
  LIBRARY_ROOT = File.dirname(__FILE__)
  PROJECT_ROOT = Pathname.new(LIBRARY_ROOT).parent
end
