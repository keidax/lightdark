require "hoop"

lib LibCF
  $ns_default_run_loop_mode = NSDefaultRunLoopMode : UInt8*
  $ns_run_loop_common_modes = NSRunLoopCommonModes : UInt8*
  $ns_event_tracking_run_loop_mode = NSEventTrackingRunLoopMode : UInt8*
  $ns_connection_reply_mode = NsConnectionReplyMode : UInt8*
end

# NSAutoreleasePool.new
# NSApp.activation_policy = LibAppKit::NSApplicationActivationPolicy::Regular

module Hoop
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

  class NSRunLoopMode < NSObject
    register_class
  end

  class NSDate < NSObject
    register_class
    static_method "dateWithTimeIntervalSinceNow:", ["NSTimeInterval"], "NSDate", "date_with_time_interval_since_now"
    method "earlierDate:", ["NSDate"], "NSDate", "earlier_date"
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

  class NSRunLoop < NSObject
    register_class
    static_method "currentRunLoop", nil, "NSRunLoop", "current_run_loop"
    static_method "mainRunLoop", nil, "NSRunLoop", "main_run_loop"
    method "currentMode", nil, "NSRunLoopMode", "current_mode"
    method "limitDateForMode:", ["NSRunLoopMode"], "NSDate", "limit_date_for_mode"
    method "runMode:beforeDate:", ["NSRunLoopMode", "NSDate"], "BOOL", "run_mode_before_date"
    method "runUntilDate:", ["NSDate"], nil, "run_until_date"
  end

  class NSApplication
    method "finishLaunching", nil, nil, "finish_launching"
    method "terminate:", ["id"], nil, "terminate"
  end
end
