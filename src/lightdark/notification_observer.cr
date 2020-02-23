require "croft"

require "../theme_controller"

class NotificationObserver < Croft::Class
  export

  def initialize(@verbose : Bool)
    super()
  end

  export_instance_method "themeChanged:", def theme_changed(notice : Croft::String)
    # notification = NSNotification.new(notice)
    case current_theme
    when /light/i
      # 🌝 🌞 🌕 🌙 🌜
      puts("🌕") if @verbose
      ThemeController.set_theme(Mode::Light)
    when /dark/i
      # 🌚 🌑
      puts("🌑") if @verbose
      ThemeController.set_theme(Mode::Dark)
    else
      puts("💀 unexpected theme #{current_theme}") if @verbose
    end
  end

  def current_theme : String
    style = Croft::UserDefaults.standard_user_defaults[Croft::String.new("AppleInterfaceStyle")].to_s

    if style.empty?
      "Light"
    else
      "Dark"
    end
  end
end
