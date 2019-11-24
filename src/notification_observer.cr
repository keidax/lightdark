require "./*"

class NotificationObserver < NSObject
  export_class
  action "theme_changed", "notice", "themeChanged:" do
    # notification = NSNotification.new(notice)

    case current_theme
    when /light/i
      # 🌝 🌞 🌕 🌙 🌜
      puts("🌕 #{LIGHT_THEME}")
      ThemeController.set_theme(Mode::LIGHT)
    when /dark/i
      # 🌚 🌑
      puts("🌑 #{DARK_THEME}")
      ThemeController.set_theme(Mode::DARK)
    else
      puts("💀 #{current_theme}")
    end
  end

  def current_theme : String
    NSUserDefaults.standard_user_defaults.string_for_key("AppleInterfaceStyle").with_default("Light")
  end
end
