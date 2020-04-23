require "croft"

DEFAULT_DARK_THEME  = "gruvbox-dark-hard"
DEFAULT_LIGHT_THEME = "one-light"

enum Mode
  Dark
  Light

  def theme
    case self
    when .dark?  then ENV.fetch("LIGHTDARK_DARK_THEME", DEFAULT_DARK_THEME)
    when .light? then ENV.fetch("LIGHTDARK_LIGHT_THEME", DEFAULT_LIGHT_THEME)
    end
  end

  def self.current : Mode
    style = Croft::UserDefaults.standard_user_defaults[Croft::String.new("AppleInterfaceStyle")].to_s

    if style.empty?
      Light
    else
      Dark
    end
  end
end
