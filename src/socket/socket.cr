require "socket"
require "./libc_additions"

class UNIXSocket
  def send_fd(fd : Int32)
    cmsg = new_cmsg(fd)
    msg = new_msg
    msg.msg_control = pointerof(cmsg)
    msg.msg_controllen = LibC::Cmsghdr.len(Int32)

    res = LibC.sendmsg(self.fd, pointerof(msg), 0)
    if res < 0
      raise Errno.new("sendmsg:")
    else
      STDERR.puts "sent: #{res}"
    end

  end

  def recv_fd : Int32
    cmsg = new_cmsg(-1)
    msg = new_msg
    msg.msg_control = pointerof(cmsg)
    msg.msg_controllen = LibC::Cmsghdr.len(Int32)

    res = LibC.recvmsg(self.fd, pointerof(msg), 0)
    if res < 0
      raise Errno.new("sendmsg:")
    end

    LibC::Cmsghdr.data(cmsg, Int32).value
  end

  private def new_cmsg(fd) : LibC::Cmsghdr
    cmsg = ControlMessageHeader.new(fd).to_unsafe
    # cmsg.cmsg_len = cmsg.len
    cmsg.cmsg_level = LibC::SOL_SOCKET
    cmsg.cmsg_type = LibC::SCM_RIGHTS
    cmsg
  end

  private def new_msg : LibC::MessageHeader
    msg = LibC::MessageHeader.new

    iov = LibC::IoVec.new
    iov.iov_len = 0

    msg.msg_iovlen = 1
    msg.msg_iov = pointerof(iov)

    msg
  end
end
