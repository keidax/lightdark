require "./*"

enum Mode
  DARK
  LIGHT
end

DARK_THEME = "gruvbox-dark-hard"
LIGHT_THEME = "one-light"

class ThemeController
  @@setters : Array(ThemeSetter) = [] of ThemeSetter

  def self.register(setter)
    @@setters << setter
  end

  def self.set_theme(mode : Mode)
    theme = case mode
            when .dark? then DARK_THEME
            when .light? then LIGHT_THEME
            else raise "unknown mode #{mode}"
            end
    @@setters.each &.set_theme(theme)
  end
end
