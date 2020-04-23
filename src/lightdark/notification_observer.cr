require "croft"

require "../theme_controller"

class NotificationObserver < Croft::Class
  export

  def initialize(@verbose : Bool)
    super()
  end

  export_instance_method "themeChanged:", def theme_changed(notice : Croft::String)
    # notification = NSNotification.new(notice)
    case Mode.current
    when .light?
      # 🌝 🌞 🌕 🌙 🌜
      puts("🌕 setting #{Mode::Light.theme}") if @verbose
      ThemeController.set_theme(Mode::Light)
    when .dark?
      # 🌚 🌑
      puts("🌑 setting #{Mode::Dark.theme}") if @verbose
      ThemeController.set_theme(Mode::Dark)
    end
  end
end
