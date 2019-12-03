require "hoop"

require "./ns_extensions"
require "../theme_controller"

class NotificationObserver < Hoop::NSObject
  include Hoop
  export_class
  action "theme_changed", "notice", "themeChanged:" do
    # notification = NSNotification.new(notice)

    case current_theme
    when /light/i
      # 🌝 🌞 🌕 🌙 🌜
      puts("🌕")
      ThemeController.set_theme(Mode::Light)
    when /dark/i
      # 🌚 🌑
      puts("🌑")
      ThemeController.set_theme(Mode::Dark)
    else
      puts("💀 #{current_theme}")
    end
  end

  def current_theme : String
    Hoop::NSUserDefaults.standard_user_defaults.string_for_key("AppleInterfaceStyle").with_default("Light")
  end
end
