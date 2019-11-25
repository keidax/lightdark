require "./*"

DARK_THEME = "gruvbox-dark-hard"
LIGHT_THEME = "one-light"

enum Mode
  Dark
  Light

  def theme
    case self
    when .dark? then DARK_THEME
    when .light? then LIGHT_THEME
    else raise "unknown mode #{self}"
    end
  end
end

class ThemeController
  @@setters : Array(ThemeSetter) = [] of ThemeSetter

  def self.register(setter)
    @@setters << setter
  end

  def self.set_theme(mode : Mode)
      @@setters.each &.set_theme(mode)
  end
end
