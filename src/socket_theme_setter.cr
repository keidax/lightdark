require "./socket"
require "./theme_setter"

class SocketThemeSetter < ThemeSetter
  @socket : UNIXServer
  @fds : Array(IO::FileDescriptor)

  def initialize
    @socket = UNIXServer.new(Path["~/lightdark.sock"].expand.to_s)
    @fds = [] of IO::FileDescriptor

    spawn do
      puts "waiting for clients"
      while client = @socket.accept?
        print "got client..."
        fd = client.recv_fd
        puts " with fd #{fd}"
        @fds << IO::FileDescriptor.new(fd)
        client.close
      end
    end

    at_exit do
      @socket.close
    end
  end

  def finalize
    @socket.close
  end

  def set_theme(mode : Mode)
    puts "sending #{mode} to #{@fds.size} fds"
    @fds.each do |fd|
      spawn do
        # fcntl doesn't seem to notice when fd is closed?
        # puts "result of #{fd} fcntl", LibC.fcntl(fd.fd, LibC::F_GETFL)

        fd.puts(mode.theme)
        fd.flush

      rescue e : Errno
        puts "fd closed: #{e}"
        @fds.delete(fd)
      end
    end
  end
end
