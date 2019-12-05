require "./mode"

abstract class ThemeSetter
  abstract def set_theme(mode : Mode)
end
