require "./*"

ThemeController.register(ShellThemeSetter.new)
ThemeController.register(VimThemeSetter.new)

handler = NotificationObserver.new
dnc = NSDistributedNotificationCenter.default_center
dnc.add_observer(handler.to_objc, "themeChanged:", "AppleInterfaceThemeChangedNotification", nil)

puts "running"
NSApp.run
puts "done"
