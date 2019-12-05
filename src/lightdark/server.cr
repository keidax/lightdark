require "croft"

require "../theme_controller"

def serve
  ThemeController.register(VimThemeSetter.new)
  ThemeController.register(TTYThemeSetter.new)

  handler = NotificationObserver.new
  dnc = Croft::DistributedNotificationCenter.default
  dnc.add_observer(handler, Croft::Selector["themeChanged:"], Croft::String.new("AppleInterfaceThemeChangedNotification"), nil)

  Croft::Application.shared_application.finish_launching

  run_loop = Croft::RunLoop.current

  Signal::INT.trap do
    # Exit quietly, closing server socket
    exit
  end

  loop do
    soon = Croft::Date.from_now(seconds: 1.0)

    run_loop.run_until(soon)
    Fiber.yield
  end
end
