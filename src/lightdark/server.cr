require "hoop"

require "../theme_controller"

include Hoop

def serve(bool : Bool)
  ThemeController.register(ShellThemeSetter.new)
  ThemeController.register(VimThemeSetter.new)
  ThemeController.register(SocketThemeSetter.new)

  handler = NotificationObserver.new
  dnc = Hoop::NSDistributedNotificationCenter.default_center
  dnc.add_observer(handler.to_objc, "themeChanged:", "AppleInterfaceThemeChangedNotification", nil)

  NSApp.finish_launching

  run_loop = NSRunLoop.current_run_loop

  Signal::INT.trap do
    # Exit quietly, closing server socket
    exit
  end

  loop do
    soon = NSDate.date_with_time_interval_since_now(1.0)

    run_loop.run_until_date(soon.to_objc)
    Fiber.yield
  end
end
