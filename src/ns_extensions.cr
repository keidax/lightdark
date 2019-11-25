require "hoop"

include Hoop

# NSAutoreleasePool.new
# NSApp.activation_policy = LibAppKit::NSApplicationActivationPolicy::Regular

class NSDistributedNotificationCenter < NSNotificationCenter
  # register_class
  # static_method "defaultCenter", nil, "NSDistributedNotificationCenter", "default_center"
  # TODO: "NSString" should really be "NSNotificationName" but I'm not sure how to make a string pointer
  # method "addObserver:selector:name:object:", ["id", "SEL", "NSString", "id"], "void", "add_observer"
end

class NSUserDefaults < NSObject
  register_class
  static_method "standardUserDefaults", nil, "NSUserDefaults", "standard_user_defaults"
  method "stringForKey:", ["NSString"], "SafeString", "string_for_key"
end

class SafeString
  @str : String?

  # Necessary to safely handle a *NSString
  def initialize(ptr : UInt8*)
    if ptr.null?
      @str = nil
    else
      @str = NSString.new(ptr).to_s
    end
  end

  def with_default(default : String)
    String
    @str || default
  end
end
