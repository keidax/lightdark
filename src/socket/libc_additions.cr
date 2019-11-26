lib LibC
  SCM_RIGHTS = 0x01

  fun recvmsg(fd : Int, message : MessageHeader*, flags : Int) : SSizeT
  fun sendmsg(fd : Int, message : MessageHeader*, flags : Int) : SSizeT

  struct IoVec
    iov_base : UInt8*
    iov_len  : SizeT
  end

  struct MessageHeader
    msg_name       : Void*
    msg_namelen    : SocklenT
    msg_iov        : IoVec*
    msg_iovlen     : SocklenT
    msg_control    : Cmsghdr*
    msg_controllen : SocklenT
    msg_flags      : Int
  end

  struct Cmsghdr
    cmsg_len : UInt
    cmsg_level : Int
    cmsg_type : Int
    # cmsg_data goes here
  end
end

macro align(x)
  ({{x}} + 3) & ~3
end

struct LibC::Cmsghdr
  macro space(type)
    align(sizeof({{@type}})) + align(sizeof({{type}}))
  end

  macro len(type)
    align(sizeof({{@type}})) + sizeof({{type}})
  end

  macro data(cmsg, type)
    (Pointer(LibC::UChar).new(pointerof({{cmsg}}).address) + align(sizeof({{@type}}))).as(Pointer({{type}}))
  end

  macro new(type)
    Pointer(LibC::UChar).malloc({{@type}}.space({{type}})).as(Pointer({{@type}})).value
  end
end

class ControlMessageHeader(T)
  @value : T = 0

  def initialize(@value : T)
    @cmsghdr = LibC::Cmsghdr.new(T)
    @cmsghdr.cmsg_len = self.len

    LibC::Cmsghdr.data(@cmsghdr, T).value = @value
  end

  def to_unsafe
    @cmsghdr
  end

  def len
    LibC::Cmsghdr.len(T)
  end
end
